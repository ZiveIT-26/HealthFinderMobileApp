import 'package:flutter/widgets.dart';

import 'app_preferences.dart';

/// Makes [AppPreferences] available to the widget tree.
///
/// - `SettingsScope.of(context)` rebuilds the caller when a setting changes.
/// - `SettingsScope.read(context)` does not; use it in callbacks.
class SettingsScope extends InheritedNotifier<AppPreferences> {
  const SettingsScope({
    super.key,
    required AppPreferences preferences,
    required super.child,
  }) : super(notifier: preferences);

  static AppPreferences of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'No SettingsScope found in context');
    return scope!.notifier!;
  }

  static AppPreferences read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'No SettingsScope found in context');
    return scope!.notifier!;
  }
}
