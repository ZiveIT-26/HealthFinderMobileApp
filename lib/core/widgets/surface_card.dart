import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Rounded card with a soft shadow: the base of every card on the profile
/// pages (profile, medical card, personal information, settings).
///
/// Filled with [color], or with [gradient] when given. With [onTap] the whole
/// card is tappable; ripples of tappable children are clipped to its shape.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.color = AppColors.white,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Gradient? gradient;
  final VoidCallback? onTap;

  static const _radius = BorderRadius.all(Radius.circular(22));
  static const _shadow = [
    BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 20),
  ];

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);

    return DecoratedBox(
      decoration: const BoxDecoration(borderRadius: _radius, boxShadow: _shadow),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: _radius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: gradient == null ? color : null,
            gradient: gradient,
            borderRadius: _radius,
          ),
          child: onTap == null ? content : InkWell(onTap: onTap, child: content),
        ),
      ),
    );
  }
}
