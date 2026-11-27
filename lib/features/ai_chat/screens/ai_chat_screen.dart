import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:health_finder/features/ai_chat/widgets/chat_history_panel.dart';
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
import '../widgets/chat_conversation.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_welcome.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  static const _moveDuration = Duration(milliseconds: 700);
  static const _moveCurve = Curves.easeInOutCubic;

  late final ChatController _chat;
  bool _chatInitialized = false;
  Timer? _availabilityTimer;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repositories = RepositoriesScope.of(context);
    if (!_chatInitialized) {
      _chat = ChatController(
        ChatApi(_backendUrl, clientFactory: authController.createClient),
        cacheStore: repositories.chatCache,
      );
      _chat.answerRemembered = _answerRemembered;
      _chatInitialized = true;
      unawaited(_chat.checkAvailability());
      _availabilityTimer = Timer.periodic(
        const Duration(seconds: 20),
        (_) => unawaited(_chat.checkAvailability()),
      );
    }
    // Settings → Privacy: the initial state of "Remember for this chat".
    _chat.rememberByDefault = SettingsScope.of(context).chatLocationRemember;
    if (_homeSub == null && repositories.currentUser.isSignedIn) {
      _homeSub = repositories.personalInfo.watch().listen(
            (info) => setState(() => _home = info.fallbackLocation),
          );
    }
  }

  @override
  void dispose() {
    _homeSub?.cancel();
    _availabilityTimer?.cancel();
    if (_chatInitialized) _chat.dispose();
    _voice.dispose(); // new
    _text.dispose(); // new
    super.dispose();
  }

  void _send(String text) {
    if (!_chat.backendAvailable) {
      _showChatError('Chat is unavailable');
      return;
    }
    // A suggestion chip can be tapped while recording.
    if (_voice.isListening) _voice.stop(); // new
    _chat.send(text);
  }

  void _newChat() {
    if (_voice.isListening) _voice.stop(); // new
    _chat.clear();
  }

  Future<void> _openHistory() async {
    await _chat.loadSessions();
    if (!mounted) return;
    if (_chat.sessionsError != null) {
      _showChatError('Could not load chat history');
      return;
    }

    await showChatHistory(
      context,
      items: _chat.sessions
          .map(
            (session) => ChatHistoryItem(
              id: session.id,
              title: session.title,
              subtitle: _chat.sessionsFromCache ? 'Saved on this device' : '',
              updatedAt: session.createdAt,
            ),
          )
          .toList(),
      onNewChat: _newChat,
      onOpen: (item) => unawaited(_openSavedChat(item)),
      onDelete: _deleteSavedChat,
      onRename: _renameSavedChat,
    );
  }

  Future<void> _openSavedChat(ChatHistoryItem item) async {
    try {
      await _chat.openSession(item.id);
    } catch (error) {
      debugPrint('Could not open chat history: $error');
      if (!mounted) return;
      if (error is ChatHistoryNotCachedException) {
        _showChatError('Open this chat while online to save it for offline use');
      } else {
        _showChatError('Could not open this chat');
      }
    }
  }

  Future<bool> _deleteSavedChat(ChatHistoryItem item) async {
    try {
      await _chat.deleteSession(item.id);
      return true;
    } catch (error) {
      debugPrint('Could not delete chat history: $error');
      if (mounted) _showChatError('Could not delete this chat');
      return false;
    }
  }

  Future<String?> _renameSavedChat(ChatHistoryItem item) async {
    var editedTitle = item.title;
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename chat'),
        content: TextFormField(
          initialValue: item.title,
          onChanged: (value) => editedTitle = value,
          autofocus: true,
          maxLength: 100,
          decoration: const InputDecoration(labelText: 'Chat name'),
          onFieldSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, editedTitle),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (title == null || title.trim().isEmpty || !mounted) return null;

    try {
      final updatedTitle = title.trim();
      await _chat.renameSession(item.id, updatedTitle);
      return updatedTitle;
    } catch (error) {
      debugPrint('Could not rename chat history: $error');
      if (mounted) _showChatError('Could not rename this chat');
      return null;
    }
  }

  void _showChatError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$message. Check your connection and try again.')),
    );
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
                  onHistory: _openHistory,
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
                            child: ChatConversation(
                              messages: _chat.messages,
                              sessionId: _chat.currentSessionId,
                              isLoading: _chat.loading,
                              homeLabel: _home?.label,
                              onCurrentLocation: (request) =>
                                  unawaited(_shareCurrentLocation(request)),
                              onHomeLocation: (request) {
                                final home = _home;
                                if (home == null) return;
                                if (_chat.beginLocationAnswer(request)) {
                                  unawaited(_shareHome(request, home));
                                }
                              },
                              onSetHome: (request) =>
                                  unawaited(_setHomeAndShare(request)),
                              onDeclineLocation: (request) =>
                                  unawaited(_declineLocation(request)),
                              onRememberChanged: _chat.setRemember,
                            ),
                          ),
                  );
                },
              ),
            ),
            // Pinned to the bottom. Rebuilds on chat state and on voice state.
            ListenableBuilder(
              listenable: Listenable.merge([_chat, _voice]),
              builder: (context, _) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_chat.cacheError != null) _buildCacheNotice(),
                  if (!_chat.backendAvailable) _buildConnectionNotice(),
                  ChatComposer(
                    controller: _text,
                    enabled: !_chat.loading && _chat.backendAvailable,
                    onSend: _send,
                    onVoiceTap: _onVoiceTap,
                    isListening: _voice.isListening,
                  ),
                ],
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
            AbsorbPointer(
              absorbing: !_chat.backendAvailable,
              child: Opacity(
                opacity: _chat.backendAvailable ? 1 : 0.5,
                child: ChatSuggestions(onSelected: _send),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionNotice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.s,
        AppSpacing.l,
        0,
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, color: AppColors.secondaryText),
          const SizedBox(width: AppSpacing.s),
          const Expanded(
            child: Text(
              'Offline. Sending is disabled; cached chats can still be opened.',
            ),
          ),
          IconButton(
            tooltip: 'Retry connection',
            onPressed: () => unawaited(_chat.checkAvailability()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheNotice() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.s,
        AppSpacing.l,
        0,
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: AppColors.secondaryText),
          SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              'Could not save this chat on the device. It may not be available offline.',
            ),
          ),
        ],
      ),
    );
  }
}
