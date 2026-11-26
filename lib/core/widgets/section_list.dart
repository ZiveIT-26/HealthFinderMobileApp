import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Scrollable column of page sections with the same gap after each one.
///
/// [belowFold] sections start just below the visible area, so they are
/// reached only by scrolling up, never tapped by accident (sign out, delete
/// account).
class SectionList extends StatelessWidget {
  const SectionList({
    super.key,
    required this.children,
    this.belowFold = const [],
    this.padding = const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, 30),
    this.gap = 10,
  });

  final List<Widget> children;
  final List<Widget> belowFold;
  final EdgeInsets padding;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: padding.copyWith(bottom: belowFold.isEmpty ? padding.bottom : 0),
          sliver: SliverList.list(children: _spaced(children)),
        ),
        if (belowFold.isNotEmpty) ...[
          // Fills the rest of the screen, pushing [belowFold] out of view.
          const SliverFillRemaining(hasScrollBody: false, child: SizedBox.shrink()),
          SliverPadding(
            padding: padding.copyWith(top: gap),
            sliver: SliverList.list(children: _spaced(belowFold)),
          ),
        ],
      ],
    );
  }

  List<Widget> _spaced(List<Widget> sections) => [
        for (final section in sections)
          Padding(padding: EdgeInsets.only(bottom: gap), child: section),
      ];
}
