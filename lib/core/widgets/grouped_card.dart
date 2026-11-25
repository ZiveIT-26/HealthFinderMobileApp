import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'surface_card.dart';

/// White card with rows separated by thin lines. Rows use [tilePadding] and
/// [tileMinHeight], so read-only and interactive rows line up.
class GroupedCard extends StatelessWidget {
  const GroupedCard({super.key, required this.children});

  final List<Widget> children;

  static const tilePadding = EdgeInsets.symmetric(horizontal: 14, vertical: 10);
  static const tileMinHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 14,
                endIndent: 14,
                color: AppColors.colorSoft,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}
