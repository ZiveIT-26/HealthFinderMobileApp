import 'package:flutter/material.dart';

import '../../../../core/widgets/page_header.dart';
import '../../../../core/widgets/screen_placeholder.dart';

class MedicalCardScreen extends StatelessWidget {
  const MedicalCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(title: 'Medical Card'),
            Expanded(child: ScreenPlaceholder(name: 'Medical Card')),
          ],
        ),
      ),
    );
  }
}
