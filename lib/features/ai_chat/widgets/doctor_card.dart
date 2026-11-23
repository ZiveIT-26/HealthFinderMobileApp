import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/chat_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final phone = doctor.phone;
    final email = doctor.email;
    final info = doctor.additionalInfo;
    final website = _websiteUri(doctor.url);

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.card, 17, AppSpacing.card, AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xxs,
        children: [
          if (doctor.speciality.isNotEmpty)
            Text(doctor.speciality, style: AppTextStyles.chatEyebrow),
          Text(
            (doctor.doctorName?.isNotEmpty ?? false) ? doctor.doctorName! : doctor.name,
            style: AppTextStyles.chatCardTitle,
          ),
          if (doctor.doctorName?.isNotEmpty ?? false)
            Text(
              doctor.name, // the place, smaller, under the doctor's name
              style: AppTextStyles.chatMeta.copyWith(color: AppColors.secondaryText),
            ), 
          if (doctor.address.isNotEmpty)
            _MetaLine(icon: Icons.location_on_outlined, text: doctor.address),
          if (phone != null && phone.isNotEmpty)
            _MetaLine(
              icon: Icons.phone_outlined,
              text: phone,
              onTap: () => _launch(context, Uri(scheme: 'tel', path: phone)),
            ),
          if (email != null && email.isNotEmpty)
            _MetaLine(
              icon: Icons.mail_outline,
              text: email,
              onTap: () => _launch(context, Uri(scheme: 'mailto', path: email)),
            ),
          if (info != null && info.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                info,
                style: AppTextStyles.chatBody.copyWith(color: AppColors.secondaryText),
              ),
            ),
          if (website != null) ...[
            const SizedBox(height: 5),
            Material(
              color: AppColors.colorBrand,
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () => _launch(context, website),
                child: SizedBox(
                  height: 38,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSpacing.s,
                    children: [
                      Text('Visit Website', style: AppTextStyles.chatButton),
                      const Icon(Icons.chevron_right, size: 20, color: AppColors.textOnAction),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.l),
              child: Row(
                spacing: AppSpacing.xs,
                children: [
                  const Icon(Icons.verified_user_outlined, size: 20, color: AppColors.colorBrand),
                  Flexible(
                    child: Text(
                      website.host,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.chatMeta.copyWith(color: AppColors.chatLink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text, this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Icon(icon, size: 20, color: AppColors.secondaryText),
        Expanded(
          child: Text(
            text,
            style: onTap == null
                ? AppTextStyles.chatMeta
                : AppTextStyles.chatMeta.copyWith(color: AppColors.chatLink),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: onTap == null ? row : InkWell(onTap: onTap, child: row),
    );
  }
}

/// The backend may send "example.com" without a scheme, which can't be launched.
Uri? _websiteUri(String raw) {
  final value = raw.trim();
  if (value.isEmpty) return null;
  final withScheme = value.startsWith('http') ? value : 'https://$value';
  final uri = Uri.tryParse(withScheme);
  return (uri == null || uri.host.isEmpty) ? null : uri;
}

Future<void> _launch(BuildContext context, Uri uri) async {
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {}

  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open this link')),
    );
  }
}