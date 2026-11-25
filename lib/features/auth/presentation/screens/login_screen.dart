import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../core/auth/auth_user.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';

/// Shown when there is no saved session. The router leaves this screen
/// by itself once [authController] reports a signed-in user.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() signIn) async {
    setState(() => _busy = true);
    debugPrint('Sign-in started');
    try {
      await signIn();
      debugPrint('Sign-in finished, signed in: ${authController.isSignedIn}');
    } on AuthException catch (e) {
      debugPrint('Sign-in failed: ${e.message}');
      _showError(e.message);
    } catch (e) {
      debugPrint('Sign-in error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 25, 24, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text('HealthFinder', textAlign: TextAlign.center, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Sign in to continue',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const Spacer(),
            AppButton.text(
              _busy ? 'Signing in...' : 'Continue with Google',
              size: AppButtonSize.large,
              expanded: true,
              onTap: _busy ? null : () => _run(authController.signInWithGoogle),
            ),
            if (kDebugMode) ...[
              const SizedBox(height: AppSpacing.m),
              AppButton.text(
                'Test login (debug only)',
                variant: AppButtonVariant.soft,
                size: AppButtonSize.large,
                expanded: true,
                onTap: _busy ? null : () => _run(authController.signInForTesting),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
