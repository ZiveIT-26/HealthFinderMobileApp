import 'package:material_ui/material_ui.dart';

import 'location_service.dart';

/// Explains why the position could not be read, with a way to fix it.
/// Shared by the chat and the home address screen.
void showLocationProblem(
  BuildContext context,
  LocationProblem problem,
  LocationService location, {
  String? extra,
}) {
  final (message, actionLabel, action) = switch (problem) {
    LocationProblem.serviceDisabled => (
        'Location is off on this device.',
        'Turn on',
        location.openLocationSettings,
      ),
    LocationProblem.denied => (
        'Location permission was not given.',
        null,
        null,
      ),
    LocationProblem.deniedForever => (
        'Location access is blocked for HealthFinder.',
        'Settings',
        location.openAppSettings,
      ),
    LocationProblem.unavailable => (
        'Could not get your location. Please try again.',
        null,
        null,
      ),
  };

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(extra == null ? message : '$message $extra'),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: action!),
      ),
    );
}
