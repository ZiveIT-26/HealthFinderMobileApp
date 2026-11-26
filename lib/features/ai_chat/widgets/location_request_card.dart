import 'package:material_ui/material_ui.dart';

import '../../../core/network/chat_controller.dart';
import '../../../core/network/chat_models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_switch.dart';

/// The assistant asks where to search: the current position, the home
/// address, or nothing. Once answered, it shrinks to one line.
///
/// With "Remember for this chat" on, the next searches of the chat use the
/// same choice without this card (the position is read again each time);
/// the location line in the chat header changes it.
///
/// Styled like the info cards of the chat in Figma (soft purple, icon tile);
/// the final look is still to be designed.
class LocationRequestCard extends StatelessWidget {
  const LocationRequestCard({
    super.key,
    required this.request,
    required this.homeLabel,
    required this.onCurrent,
    required this.onHome,
    required this.onSetHome,
    required this.onDecline,
    required this.onRememberChanged,
  });

  final LocationRequest request;

  /// The saved home address, or null when none is set.
  final String? homeLabel;

  final VoidCallback onCurrent;
  final VoidCallback onHome;

  /// Opens the home address screen (when [homeLabel] is null).
  final VoidCallback onSetHome;
  final VoidCallback onDecline;
  final ValueChanged<bool> onRememberChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: !request.isOpen
          ? _summary()
          : request.automatic
              ? _answering()
              : _question(),
    );
  }

  Widget _question() {
    final busy = request.status == LocationRequestStatus.sending;
    final home = homeLabel;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.colorSoft,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.m,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.m,
            children: [
              const _IconTile(icon: Icons.location_on_outlined),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text('Where should I search?', style: AppTextStyles.label),
                    Text(
                      request.reason ??
                          'Share a location so I can show the nearest doctors first.',
                      style: AppTextStyles.meta,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppButton(
            leading: const Icon(Icons.my_location),
            expanded: true,
            onTap: busy ? null : onCurrent,
            child: const Text('Use my current location'),
          ),
          AppButton(
            variant: AppButtonVariant.soft,
            backgroundColor: AppColors.white,
            leading: const Icon(Icons.home_outlined),
            expanded: true,
            onTap: busy ? null : (home == null ? onSetHome : onHome),
            child: Text(home == null ? 'Set my home address' : 'Home · $home'),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Remember for this chat',
                  style: AppTextStyles.meta,
                ),
              ),
              AppSwitch(
                value: request.remember,
                onChanged: busy ? null : onRememberChanged,
              ),
            ],
          ),
          if (busy)
            const Center(
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.colorBrand,
                ),
              ),
            )
          else
            AppButton.text(
              'Not now',
              variant: AppButtonVariant.soft,
              size: AppButtonSize.small,
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.secondaryText,
              onTap: onDecline,
            ),
          Text(
            'Used only in this chat, to sort results by distance. '
            'The assistant sees the town, not the exact point.',
            textAlign: TextAlign.center,
            style: AppTextStyles.chatFootnote,
          ),
        ],
      ),
    );
  }

  /// Answered with the remembered choice: no question, just progress.
  Widget _answering() {
    return Row(
      spacing: AppSpacing.xs,
      children: [
        const SizedBox.square(
          dimension: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.colorBrand,
          ),
        ),
        Expanded(
          child: Text('Finding where to search…', style: AppTextStyles.chatMeta),
        ),
      ],
    );
  }

  Widget _summary() {
    final (icon, text) = switch (request.status) {
      LocationRequestStatus.shared => (
          request.sharedSource == SharedLocationSource.home
              ? Icons.home_outlined
              : Icons.my_location,
          [
            request.sharedSource == SharedLocationSource.home
                ? 'Searching near your home'
                : 'Searching near your current location',
            ?request.sharedLabel,
          ].join(' · '),
        ),
      LocationRequestStatus.declined => (
          Icons.location_off_outlined,
          'Location not shared',
        ),
      _ => (Icons.location_off_outlined, 'No location was shared'),
    };

    return Row(
      spacing: AppSpacing.xs,
      children: [
        Icon(icon, size: 16, color: AppColors.colorBrand),
        Expanded(child: Text(text, style: AppTextStyles.chatMeta)),
      ],
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 20, color: AppColors.colorBrand),
    );
  }
}
