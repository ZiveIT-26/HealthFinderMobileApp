import 'package:flutter/material.dart';

import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/screen_placeholder.dart';

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen({super.key, required this.clinicId});

  /// Ідентифікатор клініки з адреси: /chat/clinic/:clinicId
  final String clinicId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Clinic Details'),
            Expanded(child: ScreenPlaceholder(name: 'Clinic $clinicId')),
          ],
        ),
      ),
    );
  }
}
