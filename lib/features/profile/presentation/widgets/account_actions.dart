import 'package:material_ui/material_ui.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../core/data/repositories.dart';
import '../../../../core/theme/theme.dart';

/// Asks for confirmation, then removes the user's data from this device
/// (`AccountService.deleteMyData`) and signs out. The backend has no account
/// deletion yet, so the Google account and the chats on the server stay.
///
/// Used by "Delete account" on the profile and "Delete local data" in
/// Settings.
Future<void> confirmDeleteMyData(BuildContext context) async {
  final account = RepositoriesScope.of(context).account;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.white,
      title: Text('Delete your data?', style: AppTextStyles.title),
      content: Text(
        'Your personal information, medical card, settings and consents '
        'will be removed from this device for good, and you will be signed '
        'out. Your Google account and your chats on the server are not '
        'affected.',
        style: AppTextStyles.body,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.actionPink),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  await account.deleteMyData();
  // Signs out of Google too and sends the app to the login screen.
  await authController.signOut();
}
