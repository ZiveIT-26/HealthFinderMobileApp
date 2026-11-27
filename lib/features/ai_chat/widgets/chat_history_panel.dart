import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';

// TODO: move these into AppColors / AppGradients once you match them to Figma.
const _purple = Color(0xFF5E2F86);
const _purpleSoft = Color(0xFF6A3A94);
const _sectionColor = Color(0xFF4A3A63);
const _hintColor = Color(0xFFA24BE0);
const _panelGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFC2F4), Color(0xFFD8C2FF), Color(0xFFCDB8FF)],
);

/// One chat in the history list.
class ChatHistoryItem {
  const ChatHistoryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.updatedAt,
    this.unread = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final DateTime updatedAt;
  final bool unread;
}

/// Opens the chats history as a panel sliding in from the left.
Future<void> showChatHistory(
  BuildContext context, {
  List<ChatHistoryItem> items = const [],
  VoidCallback? onNewChat,
  ValueChanged<ChatHistoryItem>? onOpen,
  Future<bool> Function(ChatHistoryItem)? onDelete,
  Future<String?> Function(ChatHistoryItem)? onRename,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close chats history',
    barrierColor: Colors.black.withValues(alpha: 0.4),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (dialogContext, _, _) {
      final width = MediaQuery.sizeOf(dialogContext).width;
      return Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: (width * 0.86).clamp(0, 400),
          child: ChatHistoryPanel(
            items: items,
            onClose: () => Navigator.of(dialogContext).pop(),
            onNewChat: () {
              Navigator.of(dialogContext).pop();
              onNewChat?.call();
            },
            onOpen: (item) {
              Navigator.of(dialogContext).pop();
              onOpen?.call(item);
            },
            onDelete: onDelete,
            onRename: onRename,
          ),
        ),
      );
    },
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return SlideTransition(
        position: Tween(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      );
    },
  );
}

class ChatHistoryPanel extends StatefulWidget {
  const ChatHistoryPanel({
    super.key,
    required this.items,
    required this.onClose,
    this.onNewChat,
    this.onOpen,
    this.onDelete,
    this.onRename,
  });

  final List<ChatHistoryItem> items;
  final VoidCallback onClose;
  final VoidCallback? onNewChat;
  final ValueChanged<ChatHistoryItem>? onOpen;
  final Future<bool> Function(ChatHistoryItem)? onDelete;
  final Future<String?> Function(ChatHistoryItem)? onRename;

  @override
  State<ChatHistoryPanel> createState() => _ChatHistoryPanelState();
}

class _ChatHistoryPanelState extends State<ChatHistoryPanel> {
  final _search = TextEditingController();
  late List<ChatHistoryItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<ChatHistoryItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items
        .where(
          (i) =>
              i.title.toLowerCase().contains(q) ||
              i.subtitle.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<bool> _delete(ChatHistoryItem item) =>
      widget.onDelete?.call(item) ?? Future<bool>.value(true);

  Future<String?> _rename(ChatHistoryItem item) async {
    final title = await widget.onRename?.call(item);
    if (title == null) return null;
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? ChatHistoryItem(
                    id: current.id,
                    title: title,
                    subtitle: current.subtitle,
                    updatedAt: current.updatedAt,
                    unread: current.unread,
                  )
                : current,
          )
          .toList();
    });
    return title;
  }

  void _remove(ChatHistoryItem item) {
    setState(() => _items.removeWhere((current) => current.id == item.id));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: _panelGradient,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(),
                const SizedBox(height: 16),
                _newChatButton(),
                const SizedBox(height: 16),
                _searchField(),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? _EmptyState(isSearch: _search.text.isNotEmpty)
                      : _HistoryList(
                          items: filtered,
                          onOpen: widget.onOpen,
                          onDelete: _delete,
                          onRename: _rename,
                          onDismissed: _remove,
                        ),
                ),
                if (_items.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Swipe left to delete · right to rename',
                    style: TextStyle(fontSize: 13, color: _hintColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Chats',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        Material(
          color: _purpleSoft,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onClose,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _newChatButton() {
    return SizedBox(
      height: 48,
      child: FilledButton.icon(
        onPressed: widget.onNewChat,
        icon: const Icon(Icons.add, size: 22),
        label: const Text(
          'New chat',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _purple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    return Container(
      height: 52,
      padding: const EdgeInsets.only(left: 14, right: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search chats',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Material(
            color: _purpleSoft,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => FocusScope.of(context).unfocus(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.search, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearch});

  final bool isSearch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 40,
              color: _sectionColor,
            ),
            const SizedBox(height: 12),
            Text(
              isSearch ? 'No chats found' : 'No chats yet',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSearch
                  ? 'Try a different search.'
                  : 'Your conversations with the assistant will appear here.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: _sectionColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({
    required this.items,
    this.onOpen,
    this.onDelete,
    this.onRename,
    this.onDismissed,
  });

  final List<ChatHistoryItem> items;
  final ValueChanged<ChatHistoryItem>? onOpen;
  final Future<bool> Function(ChatHistoryItem)? onDelete;
  final Future<String?> Function(ChatHistoryItem)? onRename;
  final ValueChanged<ChatHistoryItem>? onDismissed;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _short = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _section(DateTime d, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return _months[d.month - 1];
  }

  String _time(DateTime d, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(d.year, d.month, d.day);
    if (today.difference(day).inDays <= 1) {
      final h = d.hour.toString().padLeft(2, '0');
      final m = d.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${d.day} ${_short[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final sorted = [...items]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final children = <Widget>[];
    String? current;
    for (final item in sorted) {
      final s = _section(item.updatedAt, now);
      if (s != current) {
        current = s;
        children.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 16, 0, 8),
            child: Text(
              s,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _sectionColor,
              ),
            ),
          ),
        );
      }
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _ChatTile(
            item: item,
            time: _time(item.updatedAt, now),
            onTap: () => onOpen?.call(item),
            onDelete: () => onDelete?.call(item) ?? Future<bool>.value(true),
            onRename: () => onRename?.call(item) ?? Future<String?>.value(null),
            onDismissed: () => onDismissed?.call(item),
          ),
        ),
      );
    }

    return ListView(padding: EdgeInsets.zero, children: children);
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({
    required this.item,
    required this.time,
    required this.onTap,
    required this.onDelete,
    required this.onRename,
    required this.onDismissed,
  });

  final ChatHistoryItem item;
  final String time;
  final VoidCallback onTap;
  final Future<bool> Function() onDelete;
  final Future<String?> Function() onRename;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      // Right swipe = rename (tile snaps back), left swipe = delete.
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await onRename();
          return false;
        }
        return onDelete();
      },
      onDismissed: (_) => onDismissed(),
      background: _swipeBg(Icons.edit, Alignment.centerLeft, _purpleSoft),
      secondaryBackground: _swipeBg(
        Icons.delete_outline,
        Alignment.centerRight,
        Colors.redAccent,
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      if (item.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: _sectionColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: _sectionColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (item.unread)
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          color: _purple,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 9, height: 9),
                      )
                    else
                      const SizedBox(height: 9),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _swipeBg(IconData icon, Alignment alignment, Color color) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}
