import 'package:material_ui/material_ui.dart';

import '../../../core/network/chat_controller.dart';
import '../../../core/theme/theme.dart';
import 'chat_messages.dart';
import 'location_request_card.dart';

class ChatConversation extends StatefulWidget {
  const ChatConversation({
    super.key,
    required this.messages,
    required this.sessionId,
    required this.isLoading,
    required this.homeLabel,
    required this.onCurrentLocation,
    required this.onHomeLocation,
    required this.onSetHome,
    required this.onDeclineLocation,
    required this.onRememberChanged,
  });

  final List<Message> messages;
  final String? sessionId;
  final bool isLoading;
  final String? homeLabel;
  final ValueChanged<LocationRequest> onCurrentLocation;
  final ValueChanged<LocationRequest> onHomeLocation;
  final ValueChanged<LocationRequest> onSetHome;
  final ValueChanged<LocationRequest> onDeclineLocation;
  final void Function(LocationRequest request, bool remember)
      onRememberChanged;

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  static const _bottomThreshold = 96.0;
  static const _listPadding = EdgeInsets.fromLTRB(17, 28, 17, AppSpacing.l);

  final _scrollController = ScrollController();
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateBottomState);
    _scheduleAutoScroll();
  }

  @override
  void didUpdateWidget(covariant ChatConversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionId != widget.sessionId) {
      _isAtBottom = true;
    }
    if (_isAtBottom) _scheduleAutoScroll();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateBottomState)
      ..dispose();
    super.dispose();
  }

  void _updateBottomState() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final isAtBottom =
        position.maxScrollExtent - position.pixels <= _bottomThreshold;
    if (_isAtBottom == isAtBottom) return;
    setState(() => _isAtBottom = isAtBottom);
  }

  void _scheduleAutoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isAtBottom || !_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _animateToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          controller: _scrollController,
          padding: _listPadding,
          itemCount: widget.messages.length,
          separatorBuilder: (_, _) => const SizedBox(height: 20),
          itemBuilder: _buildMessage,
        ),
        if (!_isAtBottom)
          Positioned(
            right: 20,
            bottom: 18,
            child: FloatingActionButton.small(
              heroTag: null,
              tooltip: 'Scroll to latest',
              backgroundColor: AppColors.colorBrand,
              foregroundColor: AppColors.white,
              onPressed: _animateToBottom,
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, int index) {
    final message = widget.messages[index];
    final isLast = index == widget.messages.length - 1;
    final request = message.locationRequest;

    return message.isUser
        ? UserBubble(text: message.text)
        : AssistantReply(
            text: message.text,
            doctors: message.doctors,
            isStreaming: widget.isLoading && isLast,
            locationTextOffset: request?.textOffset ?? 0,
            awaitingLocation: request?.isOpen ?? false,
            location: request == null
                ? null
                : LocationRequestCard(
                    request: request,
                    homeLabel: widget.homeLabel,
                    onCurrent: () => widget.onCurrentLocation(request),
                    onHome: () => widget.onHomeLocation(request),
                    onSetHome: () => widget.onSetHome(request),
                    onDecline: () => widget.onDeclineLocation(request),
                    onRememberChanged: (value) =>
                        widget.onRememberChanged(request, value),
                  ),
          );
  }
}
