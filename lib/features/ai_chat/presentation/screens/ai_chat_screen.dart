import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Health Assistant', style: AppTextStyles.title),
            Text('Care guidance & clinic finder', style: AppTextStyles.meta),
            const Spacer(),
            // TODO: тимчасова кнопка замість картки клініки в чаті
            FilledButton(
              onPressed: () => context.push(AppRoutes.clinicDetails('neurol-emg')),
              child: const Text('View Clinic'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
