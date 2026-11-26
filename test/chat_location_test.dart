import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:health_finder/core/location/location_service.dart';
import 'package:health_finder/core/network/chat_api.dart';
import 'package:health_finder/core/network/chat_controller.dart';
import 'package:health_finder/core/network/chat_models.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake backend: POST /chat, an SSE stream the test writes to (a new one
/// for every message), and POST /chat/location.
class _FakeBackend {
  var sse = StreamController<List<int>>();
  final locationAnswers = <Map<String, dynamic>>[];
  int locationStatus = 204;

  void send(Map<String, dynamic> event) =>
      sse.add(utf8.encode('data: ${jsonEncode(event)}\n\n'));

  http.Client client() => MockClient.streaming((request, body) async {
        final path = request.url.path;
        if (path == '/chat' && request.method == 'POST') {
          sse = StreamController<List<int>>();
          return _json({'streamId': 's1', 'sessionId': 'session-1'}, 201);
        }
        if (path == '/chat/stream/s1') {
          return http.StreamedResponse(sse.stream, 200);
        }
        if (path == '/chat/location') {
          locationAnswers.add(
            jsonDecode(await utf8.decodeStream(body)) as Map<String, dynamic>,
          );
          return http.StreamedResponse(const Stream.empty(), locationStatus);
        }
        return http.StreamedResponse(const Stream.empty(), 404);
      });

  static http.StreamedResponse _json(Object value, int status) =>
      http.StreamedResponse(Stream.value(utf8.encode(jsonEncode(value))), status);
}

Future<void> _settle() => Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  group('chat location request', () {
    late _FakeBackend backend;
    late ChatController chat;

    setUp(() {
      backend = _FakeBackend();
      chat = ChatController(
        ChatApi('http://test', clientFactory: backend.client),
      );
    });

    tearDown(() => chat.dispose());

    test('the question is placed after the text streamed before it', () async {
      await chat.send('Find me a dentist');
      backend.send({'type': 'token', 'text': 'Let me check. '});
      backend.send({
        'type': 'location_request',
        'requestId': 'r1',
        'reason': 'To find dentists near you',
      });
      await _settle();

      final request = chat.messages.last.locationRequest!;
      expect(request.requestId, 'r1');
      expect(request.reason, 'To find dentists near you');
      expect(request.textOffset, 'Let me check. '.length);
      expect(request.status, LocationRequestStatus.pending);
    });

    test('sharing sends coordinates and the town, never the street', () async {
      await chat.send('Find me a dentist');
      backend.send({'type': 'location_request', 'requestId': 'r1'});
      await _settle();
      final request = chat.messages.last.locationRequest!;

      final sent = await chat.answerLocation(
        request,
        const LocationShared(
          source: SharedLocationSource.home,
          latitude: 48.72,
          longitude: 21.25,
          area: 'Košice - Staré Mesto',
        ),
        shownLabel: 'Hlavná 1, Košice',
      );

      expect(sent, isTrue);
      expect(backend.locationAnswers.single, {
        'requestId': 'r1',
        'source': 'home',
        'location': {'lat': 48.72, 'lon': 21.25, 'label': 'Košice - Staré Mesto'},
      });
      expect(request.status, LocationRequestStatus.shared);
      expect(request.sharedLabel, 'Hlavná 1, Košice');
    });

    test('declining sends only the request id', () async {
      await chat.send('Find me a dentist');
      backend.send({'type': 'location_request', 'requestId': 'r1'});
      await _settle();
      final request = chat.messages.last.locationRequest!;

      await chat.answerLocation(request, const LocationDeclined());
      expect(backend.locationAnswers.single, {
        'requestId': 'r1',
        'source': 'declined',
      });
      expect(request.status, LocationRequestStatus.declined);
    });

    test('a request the server forgot (404) expires', () async {
      backend.locationStatus = 404;
      await chat.send('Find me a dentist');
      backend.send({'type': 'location_request', 'requestId': 'r1'});
      await _settle();
      final request = chat.messages.last.locationRequest!;

      expect(await chat.answerLocation(request, const LocationDeclined()), isFalse);
      expect(request.status, LocationRequestStatus.expired);
    });

    test('an unanswered question expires when the reply ends', () async {
      await chat.send('Find me a dentist');
      backend.send({'type': 'location_request', 'requestId': 'r1'});
      await backend.sse.close();
      await _settle();

      expect(
        chat.messages.last.locationRequest!.status,
        LocationRequestStatus.expired,
      );
      expect(chat.loading, isFalse);
    });
  });

  group('location choice for the whole chat', () {
    late _FakeBackend backend;
    late ChatController chat;
    late List<LocationChoice> answeredBySelf;

    const home = LocationShared(
      source: SharedLocationSource.home,
      latitude: 48.72,
      longitude: 21.25,
      area: 'Košice - Staré Mesto',
    );

    setUp(() {
      backend = _FakeBackend();
      chat = ChatController(
        ChatApi('http://test', clientFactory: backend.client),
      );
      answeredBySelf = [];
      // What the chat screen does: read the position or the home address.
      chat.answerRemembered = (request, choice) async {
        answeredBySelf.add(choice);
        if (chat.beginLocationAnswer(request)) {
          await chat.answerLocation(request, home);
        }
      };
    });

    tearDown(() => chat.dispose());

    /// Sends a message and waits for its location request.
    Future<LocationRequest> ask({bool change = false}) async {
      await chat.send('Find me a dentist');
      backend.send({
        'type': 'location_request',
        'requestId': 'r${backend.locationAnswers.length + 1}',
        if (change) 'change': true,
      });
      await _settle();
      return chat.messages.last.locationRequest!;
    }

    Future<void> endReply() async {
      await backend.sse.close();
      await _settle();
    }

    test('a remembered choice answers the next search without the card', () async {
      final first = await ask();
      expect(first.remember, isTrue);
      await chat.answerLocation(first, home);
      expect(chat.rememberedLocation, LocationChoice.home);
      await endReply();

      final second = await ask();
      expect(answeredBySelf, [LocationChoice.home]);
      expect(second.automatic, isTrue);
      expect(second.status, LocationRequestStatus.shared);
      expect(backend.locationAnswers, hasLength(2));
    });

    test('with "Remember for this chat" off, the card is shown again', () async {
      final first = await ask();
      chat.setRemember(first, false);
      await chat.answerLocation(first, home);
      expect(chat.rememberedLocation, isNull);
      await endReply();

      final second = await ask();
      expect(answeredBySelf, isEmpty);
      expect(second.status, LocationRequestStatus.pending);
    });

    test('the setting decides the initial state of the switch', () async {
      chat.rememberByDefault = false;
      expect((await ask()).remember, isFalse);
    });

    test('the choice the user made is remembered, not the fallback', () async {
      final first = await ask();
      // "Current location" without GPS: the home address was sent instead.
      await chat.answerLocation(first, home, choice: LocationChoice.current);
      expect(chat.rememberedLocation, LocationChoice.current);
    });

    test('"change" from the assistant shows the card despite a choice', () async {
      chat.setRememberedLocation(LocationChoice.home);
      final request = await ask(change: true);
      expect(answeredBySelf, isEmpty);
      expect(request.status, LocationRequestStatus.pending);
      expect(request.remember, isTrue);
    });

    test('"New chat" forgets the choice', () async {
      chat.setRememberedLocation(LocationChoice.current);
      chat.clear();
      expect(chat.rememberedLocation, isNull);
    });
  });

  group('place names', () {
    test('town and district for the assistant, street for the user', () {
      final names = LocationService.namesOf(
        const Placemark(
          locality: 'Košice',
          subLocality: 'Staré Mesto',
          thoroughfare: 'Hlavná',
          subThoroughfare: '1',
        ),
      )!;
      expect(names.area, 'Košice - Staré Mesto');
      expect(names.address, 'Hlavná 1, Košice');
    });

    test('without a town the assistant gets no name', () {
      final names = LocationService.namesOf(
        const Placemark(thoroughfare: 'Hlavná', subThoroughfare: '1'),
      )!;
      expect(names.address, 'Hlavná 1');
      expect(names.area, isNull);
    });

    test('nothing known -> null', () {
      expect(LocationService.namesOf(const Placemark()), isNull);
    });
  });
}
