class Doctor {
  final String name, speciality, address, url;
  final String? doctorName, phone, email, additionalInfo;

  Doctor.fromJson(Map<String, dynamic> j)
      : name = j['name'] ?? '',
        doctorName = j['doctorName'],
        speciality = j['speciality'] ?? '',
        address = j['address'] ?? '',
        url = j['url'] ?? '',
        phone = j['phone'],
        email = j['email'],
        additionalInfo = j['additionalInfo'];
}

// One class per kind of SSE event your server sends
sealed class ChatEvent {}

class TokenEvent extends ChatEvent {
  final String text;
  TokenEvent(this.text);
}

class DoctorsEvent extends ChatEvent {
  final List<Doctor> doctors;
  DoctorsEvent(this.doctors);
}

class ErrorEvent extends ChatEvent {
  final String message;
  ErrorEvent(this.message);
}

class HeartbeatEvent extends ChatEvent {}

/// The assistant waits for the user's location. Answer it with
/// `ChatApi.answerLocation`; the stream continues after that, or after about
/// two minutes without an answer.
class LocationRequestEvent extends ChatEvent {
  final String requestId;

  /// Optional short text from the assistant, e.g. "To find doctors near you".
  final String? reason;

  /// The user asked to search somewhere else: show the choice even when one
  /// is remembered for this chat.
  final bool change;
  LocationRequestEvent(this.requestId, this.reason, {this.change = false});
}

/// Where a location shared in the chat comes from.
enum SharedLocationSource { current, home }

/// What the user picked on the location card. Remembered for the rest of the
/// chat when they keep "Remember for this chat" on.
enum LocationChoice { current, home, none }

/// The user's answer to a [LocationRequestEvent].
sealed class LocationAnswer {
  const LocationAnswer();
}

class LocationShared extends LocationAnswer {
  const LocationShared({
    required this.source,
    required this.latitude,
    required this.longitude,
    this.area,
  });

  final SharedLocationSource source;
  final double latitude;
  final double longitude;

  /// Town-level name for the assistant ("Košice - Staré Mesto"), never a
  /// street. The model sees only this, the server uses the coordinates.
  final String? area;
}

class LocationDeclined extends LocationAnswer {
  const LocationDeclined();
}

/// The server no longer waits for this answer (answered, timed out, or the
/// stream has ended).
class LocationRequestExpired implements Exception {
  const LocationRequestExpired();

  @override
  String toString() => 'LocationRequestExpired';
}