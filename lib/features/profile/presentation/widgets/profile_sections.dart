import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../data/profile_mock_data.dart';

/// Top card with avatar, name, subtitle and an optional [action] button.
class ProfileHero extends StatelessWidget {
  const ProfileHero({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.action,
  });

  final String name;
  final String subtitle;
  final Widget? action;

  /// Google profile photo; the placeholder icon is shown without it or offline.
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 22),
      child: Row(
        spacing: 15,
        children: [
          Container(
            width: 55,
            height: 55,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.colorSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: avatarUrl == null
                ? const _AvatarPlaceholder()
                : Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const _AvatarPlaceholder(),
                  ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Text(name, style: AppTextStyles.heroName),
                Text(subtitle, style: AppTextStyles.body),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.person_outline, size: 20, color: AppColors.colorBrand);
}

/// Settings row: icon tile, title, subtitle and a chevron.
class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.item});

  final SettingsItem item;

  @override
  Widget build(BuildContext context) {
    final route = item.route;

    return SurfaceCard(
      onTap: route == null ? null : () => context.push(route),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 43),
        child: Row(
          spacing: 13,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: AppColors.colorSoft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(item.icon, size: 20, color: AppColors.colorBrand),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(item.title, style: AppTextStyles.detailLabel),
                  Text(item.subtitle, style: AppTextStyles.body),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.ink),
          ],
        ),
      ),
    );
  }
}
