import 'package:health_finder/core/widgets/app_button.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/content_card.dart';
import '../../data/clinic_mock_data.dart';

/// Top card with category, clinic name and doctor.
class ClinicHero extends StatelessWidget {
  const ClinicHero({super.key, required this.clinic});

  final ClinicDetails clinic;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: AppGradients.detailHero,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 3,
        children: [
          Text(clinic.kicker.toUpperCase(), style: AppTextStyles.detailKicker),
          Text(clinic.name, style: AppTextStyles.detailStrong),
          Text(clinic.doctor, style: AppTextStyles.detailBody),
        ],
      ),
    );
  }
}

/// "Call Clinic" and "Directions" buttons (not interactive yet).
class ClinicActions extends StatelessWidget {
  const ClinicActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: AppButton.text(
            'Call Clinic',
            leading: Icon(Icons.phone_outlined),
            expanded: true,
            onTap: () {},
          ),
        ),
        Expanded(
          child: AppButton.text(
            'Directions',
            leading: Icon(Icons.location_on_outlined),
            variant: AppButtonVariant.soft,
            expanded: true,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

/// Address, phone and email with icons.
class ClinicContacts extends StatelessWidget {
  const ClinicContacts({super.key, required this.clinic});

  final ClinicDetails clinic;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        children: [
          _ContactRow(icon: Icons.location_on_outlined, label: 'Address', value: clinic.address),
          _ContactRow(icon: Icons.phone_outlined, label: 'Phone', value: clinic.phone),
          _ContactRow(icon: Icons.info_outline, label: 'Email', value: clinic.email),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.m,
        children: [
          Icon(icon, size: 20, color: AppColors.colorBrand),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(label, style: AppTextStyles.detailLabel),
                Text(value, style: AppTextStyles.detailValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Opening hours as a two-column list.
class ClinicOpeningHours extends StatelessWidget {
  const ClinicOpeningHours({super.key, required this.hours});

  final List<OpeningHours> hours;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        spacing: 9,
        children: [
          for (final row in hours)
            Row(
              children: [
                Expanded(child: Text(row.days, style: AppTextStyles.detailRow)),
                Text(row.time, style: AppTextStyles.detailRowValue),
              ],
            ),
        ],
      ),
    );
  }
}

/// Link to the official listing plus a hint (link not interactive yet).
class ClinicSource extends StatelessWidget {
  const ClinicSource({super.key, required this.clinic});

  final ClinicDetails clinic;

  @override
  Widget build(BuildContext context) {
    return ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Text(
            clinic.sourceLabel,
            style: AppTextStyles.detailValue.copyWith(
              color: AppColors.colorBrand,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(clinic.sourceHint, style: AppTextStyles.detailBody),
        ],
      ),
    );
  }
}
