import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:health_finder/features/ai_chat/widgets/chat_suggestions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:health_finder/core/auth/auth_controller.dart';
import 'package:health_finder/core/network/chat_api.dart';
import 'package:health_finder/core/network/chat_controller.dart';
import 'package:health_finder/features/ai_chat/widgets/voice_input_contoller.dart';

import '../../../core/data/repositories.dart';
import '../../../core/location/location_service.dart';
import '../../../core/location/show_location_problem.dart';
import '../../../core/network/chat_models.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/storage/settings_scope.dart';
import '../../../core/theme/theme.dart';
import '../../profile/data/models/personal_info.dart';
import '../../profile/presentation/widgets/settings_controls.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_welcome.dart';
import '../widgets/location_request_card.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  static const _moveDuration = Duration(milliseconds: 700);
  static const _moveCurve = Curves.easeInOutCubic;

  late final ChatController _chat;
  final _scroll = ScrollController();
  final _backendUrl = dotenv.get("BACKEND_URL");

  /// Text field of the composer. The screen owns it so that voice input can
  /// write into it.
  final _text = TextEditingController(); // new

  /// Dictation with the phone's built-in speech recognition.
  final _voice = VoiceInputController(
    // localeId: 'en_US', // set it if the app isn't English-only
    // onDeviceOnly: true, // keep audio on the phone (see notes in chat)
  ); // new

  /// Height of the bottom block, so the message list can end above it.
  double _bottomBlockHeight = 0;

  /// Answers the assistant's "where should I search?" (see [LocationRequestCard]).
  final _location = const LocationService();

  /// The saved home address, the fallback when the current position is not
  /// available. Kept up to date while the chat is open.
  FallbackLocation? _home;
  StreamSubscription<PersonalInfo>? _homeSub;

  @override
  void initState() {
    super.initState();
    _chat = ChatController(
      ChatApi(_backendUrl, clientFactory: authController.createClient),
    );
    _chat.addListener(_scrollToBottom);
    _chat.answerRemembered = _answerRemembered;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Settings → Privacy: the initial state of "Remember for this chat".
    _chat.rememberByDefault = SettingsScope.of(context).chatLocationRemember;
    final repositories = RepositoriesScope.of(context);
    if (_homeSub == null && repositories.currentUser.isSignedIn) {
      _homeSub = repositories.personalInfo.watch().listen(
            (info) => setState(() => _home = info.fallbackLocation),
          );
    }
  }

  @override
  void dispose() {
    _homeSub?.cancel();
    _chat.removeListener(_scrollToBottom);
    _chat.dispose();
    _voice.dispose(); // new
    _text.dispose(); // new
    _scroll.dispose();
    super.dispose();
  }

  /// Runs on every notifyListeners(), so the view follows streaming tokens.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  void _send(String text) {
    // A suggestion chip can be tapped while recording.
    if (_voice.isListening) _voice.stop(); // new
    _chat.send(text);
  }

  void _newChat() {
    if (_voice.isListening) _voice.stop(); // new
    _chat.clear();
  }

  // ---------------------------------------------------------------------------
  // Location question of the assistant
  // ---------------------------------------------------------------------------

  /// "Use my current location". Without permission or GPS, the home address
  /// is used instead when one is saved (the fallback).
  Future<void> _shareCurrentLocation(LocationRequest request) async {
    if (!_chat.beginLocationAnswer(request)) return;

    final result = await _location.currentPosition();
    if (!mounted) return;

    switch (result) {
      case PositionFound(:final latitude, :final longitude):
        final names = await _location.placeNames(latitude, longitude);
        await _answerLocation(
          request,
          LocationShared(
            source: SharedLocationSource.current,
            latitude: latitude,
            longitude: longitude,
            area: names?.area,
          ),
          shownLabel: names?.area,
        );
      case PositionFailed(:final problem):
        final home = _home;
        if (home == null) {
          _chat.cancelLocationAnswer(request);
          showLocationProblem(context, problem, _location);
          return;
        }
        showLocationProblem(
          context,
          problem,
          _location,
          extra: 'Your home address is used instead.',
        );
        // Remembered as "current": the next search tries the position again.
        await _shareHome(request, home, choice: LocationChoice.current);
    }
  }

  /// "Home · …": the saved home address.
  Future<void> _shareHome(
    LocationRequest request,
    FallbackLocation home, {
    LocationChoice choice = LocationChoice.home,
  }) async {
    // Only the town goes to the assistant, not the saved street address.
    final names = await _location.placeNames(home.latitude, home.longitude);
    if (!mounted) return;
    await _answerLocation(
      request,
      LocationShared(
        source: SharedLocationSource.home,
        latitude: home.latitude,
        longitude: home.longitude,
        area: names?.area,
      ),
      shownLabel: home.label,
      choice: choice,
    );
  }

  /// No home address yet: set it on the map, then share it right away.
  Future<void> _setHomeAndShare(LocationRequest request) async {
    final home = await context.push<FallbackLocation>(AppRoutes.homeLocation);
    if (home == null || !mounted || !request.isOpen) return;
    if (!_chat.beginLocationAnswer(request)) return;
    await _shareHome(request, home);
  }

  Future<void> _declineLocation(LocationRequest request) =>
      _answerLocation(request, const LocationDeclined());

  /// A choice remembered for this chat answers the next request by itself,
  /// with a fresh position or the current home address.
  Future<void> _answerRemembered(
    LocationRequest request,
    LocationChoice choice,
  ) async {
    switch (choice) {
      case LocationChoice.current:
        await _shareCurrentLocation(request);
      case LocationChoice.home:
        final home = _home;
        if (home == null) {
          // The home address was removed meanwhile: ask on the card.
          request.automatic = false;
          _chat.setRememberedLocation(null);
          return;
        }
        if (_chat.beginLocationAnswer(request)) await _shareHome(request, home);
      case LocationChoice.none:
        await _declineLocation(request);
    }
  }

  /// The header's subtitle: where the assistant searches in this chat. Null
  /// (title only) until the user first answered the location question.
  String? _locationSubtitle() {
    final requests = _chat.messages
        .map((m) => m.locationRequest)
        .whereType<LocationRequest>();
    switch (_chat.rememberedLocation) {
      case null:
        final answered = requests.any((r) =>
            r.status == LocationRequestStatus.shared ||
            r.status == LocationRequestStatus.declined);
        return answered ? 'Location: ask each time' : null;
      case LocationChoice.current:
        // The town of the latest position, when one was read.
        final town = requests
            .where((r) =>
                r.status == LocationRequestStatus.shared &&
                r.sharedSource == SharedLocationSource.current)
            .map((r) => r.sharedLabel)
            .lastOrNull;
        return ['Current location', ?town].join(' · ');
      case LocationChoice.home:
        // The street would not fit; the card and the sheet show it.
        return 'Near home';
      case LocationChoice.none:
        return 'Without a location';
    }
  }

  /// The header's location line: where to search for the rest of the chat.
  Future<void> _changeRememberedLocation() async {
    final home = _home;
    final picked = await showOptionsSheet<LocationChoice?>(
      context: context,
      title: 'Where to search in this chat',
      options: [
        const SheetOption(LocationChoice.current, 'My current location'),
        if (home != null) SheetOption(LocationChoice.home, 'Home · ${home.label}'),
        const SheetOption(LocationChoice.none, 'Without a location'),
        const SheetOption(null, 'Ask me each time'),
      ],
      selected: _chat.rememberedLocation,
      note: 'For the next searches in this chat.',
    );
    if (picked != null) _chat.setRememberedLocation(picked.value);
  }

  Future<void> _answerLocation(
    LocationRequest request,
    LocationAnswer answer, {
    String? shownLabel,
    LocationChoice? choice,
  }) async {
    try {
      await _chat.answerLocation(
        request,
        answer,
        shownLabel: shownLabel,
        choice: choice,
      );
    } catch (error) {
      debugPrint('Could not send the location answer: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not send it. Check your connection and try again.'),
        ),
      );
    }
  }

  Future<void> _onVoiceTap() async {
    final ok = await _voice.toggle(_text);
    if (ok || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Voice input is not available. '
          'Check microphone and speech recognition permissions in Settings.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ListenableBuilder(
              listenable: _chat,
              builder: (context, _) {
                final location = _locationSubtitle();
                return ChatHeader(
                  onNewChat: _chat.messages.isEmpty || _chat.loading ? null : _newChat,
                  onHistory: () {}, // TODO: open chats history
                  location: location,
                  onLocationTap:
                      location == null ? null : _changeRememberedLocation,
                );
              },
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _chat,
                builder: (context, _) {
                  final isEmpty = _chat.messages.isEmpty;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isEmpty
                        ? _buildWelcome()
                        : KeyedSubtree(
                            key: const ValueKey('messages'),
                            child: _buildMessageList(),
                          ),
                  );
                },
              ),
            ),
            // Pinned to the bottom. Rebuilds on chat state and on voice state.
            ListenableBuilder(
              listenable: Listenable.merge([_chat, _voice]),
              builder: (context, _) => ChatComposer(
                controller: _text,
                enabled: !_chat.loading,
                onSend: _send,
                onVoiceTap: _onVoiceTap,
                isListening: _voice.isListening,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Greeting card + "Try asking" chips. Scrolls if the keyboard shrinks the space.
  Widget _buildWelcome() {
    // Full height, so AnimatedSwitcher (which centers smaller children)
    // keeps the welcome content at the top.
    return SizedBox.expand(
      key: const ValueKey('welcome'),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ChatGreeting(),
            ChatSuggestions(onSelected: _send),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    final messages = _chat.messages;

    return ListView.separated(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(17, 28, 17, AppSpacing.l),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final m = messages[index];
        final isLast = index == messages.length - 1;
        final request = m.locationRequest;

        return m.isUser
            ? UserBubble(text: m.text)
            : AssistantReply(
                text: m.text,
                doctors: m.doctors,
                isStreaming: _chat.loading && isLast,
                locationTextOffset: request?.textOffset ?? 0,
                awaitingLocation: request?.isOpen ?? false,
                location: request == null
                    ? null
                    : LocationRequestCard(
                        request: request,
                        homeLabel: _home?.label,
                        onCurrent: () => _shareCurrentLocation(request),
                        onHome: () {
                          final home = _home;
                          if (home == null) return;
                          if (_chat.beginLocationAnswer(request)) {
                            _shareHome(request, home);
                          }
                        },
                        onSetHome: () => _setHomeAndShare(request),
                        onDecline: () => _declineLocation(request),
                        onRememberChanged: (value) =>
                            _chat.setRemember(request, value),
                      ),
              );
      },
    );
  }
}