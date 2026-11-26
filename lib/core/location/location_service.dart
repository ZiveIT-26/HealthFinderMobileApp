import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Where the app searches when nothing else is known: the centre of Košice,
/// the region the backend covers.
const kosiceCentre = (latitude: 48.7164, longitude: 21.2611);

/// Why the current position could not be read.
enum LocationProblem {
  /// Location is switched off on the device.
  serviceDisabled,

  /// The user said no. The app may ask again next time.
  denied,

  /// The user said "don't ask again" (Android) or denied it (iOS): only the
  /// system settings can change it.
  deniedForever,

  /// No position in time, or a platform error.
  unavailable,
}

/// The result of [LocationService.currentPosition].
sealed class PositionResult {
  const PositionResult();
}

final class PositionFound extends PositionResult {
  const PositionFound(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

final class PositionFailed extends PositionResult {
  const PositionFailed(this.problem);

  final LocationProblem problem;
}

/// Whether the app may read the position right now, checked without asking.
enum LocationAccess { allowed, notAsked, deniedForever, serviceDisabled }

/// Names of a place, from reverse geocoding on the device (no API key, no
/// server of ours involved).
class PlaceNames {
  const PlaceNames({required this.address, required this.area});

  /// For the user, street level: "Hlavná 1, Košice".
  final String address;

  /// For the assistant, town level: "Košice - Staré Mesto". Never a street,
  /// so a home address does not reach the model. Null when the town is not
  /// known.
  final String? area;
}

/// The device's location: permission, current position and place names.
///
/// The permission dialog is shown only when the user asks for the current
/// position (like voice input asks on the first tap), never at startup.
/// The app reads the position once per request, only while it is open.
class LocationService {
  const LocationService();

  static const _positionTimeout = Duration(seconds: 15);

  /// Current permission state, without showing a dialog.
  Future<LocationAccess> access() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }
    return switch (await Geolocator.checkPermission()) {
      LocationPermission.always ||
      LocationPermission.whileInUse =>
        LocationAccess.allowed,
      LocationPermission.deniedForever => LocationAccess.deniedForever,
      // Android reports "denied" both before the first question and after a
      // plain "no"; both mean the app may still ask.
      LocationPermission.denied ||
      LocationPermission.unableToDetermine =>
        LocationAccess.notAsked,
    };
  }

  /// Asks for permission if needed, then reads the position once.
  Future<PositionResult> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const PositionFailed(LocationProblem.serviceDisabled);
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      switch (permission) {
        case LocationPermission.denied:
          return const PositionFailed(LocationProblem.denied);
        case LocationPermission.deniedForever:
          return const PositionFailed(LocationProblem.deniedForever);
        case LocationPermission.unableToDetermine:
          return const PositionFailed(LocationProblem.unavailable);
        case LocationPermission.whileInUse || LocationPermission.always:
          break;
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          // About 100 m is enough to sort doctors by distance, and it is
          // faster indoors than a GPS fix. On Android with Google's
          // "Location Accuracy" off, Play Services shows its own dialog about
          // it (with any accuracy); it does not block this call.
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: _positionTimeout,
          ),
        );
        return PositionFound(position.latitude, position.longitude);
      } on TimeoutException {
        // Indoors a new fix can take long; a recent one is good enough.
        final last = await Geolocator.getLastKnownPosition();
        return last == null
            ? const PositionFailed(LocationProblem.unavailable)
            : PositionFound(last.latitude, last.longitude);
      }
    } catch (error) {
      debugPrint('Could not read the position: $error');
      return const PositionFailed(LocationProblem.unavailable);
    }
  }

  /// Names of the place at a point, or null when the device has no
  /// geocoder or no network.
  Future<PlaceNames?> placeNames(double latitude, double longitude) async {
    try {
      final places = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return places.isEmpty ? null : namesOf(places.first);
    } catch (error) {
      debugPrint('Reverse geocoding failed: $error');
      return null;
    }
  }

  /// System settings of this app, where the user can allow location after
  /// "don't ask again".
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  /// The device's location switch.
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @visibleForTesting
  static PlaceNames? namesOf(Placemark place) {
    String? clean(String? value) {
      final text = value?.trim();
      return text == null || text.isEmpty ? null : text;
    }

    final town = clean(place.locality) ??
        clean(place.subAdministrativeArea) ??
        clean(place.administrativeArea);
    final district = clean(place.subLocality);
    final street = [
      clean(place.thoroughfare),
      clean(place.subThoroughfare),
    ].whereType<String>().join(' ');

    final area = [
      town,
      if (district != null && district != town) district,
    ].whereType<String>().join(' - ');
    final address = [
      if (street.isNotEmpty) street,
      town,
    ].whereType<String>().join(', ');

    if (address.isEmpty) return null;
    return PlaceNames(address: address, area: area.isEmpty ? null : area);
  }
}

/// Short coordinates for when a place has no name: "48.7164, 21.2611".
String formatCoordinates(double latitude, double longitude) =>
    '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
