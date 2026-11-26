import 'dart:async';
import 'dart:math' show Point;

import 'package:go_router/go_router.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/data/repositories.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/location/show_location_problem.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/page_header.dart';
import '../../data/models/personal_info.dart';

/// Map tiles: OpenFreeMap (free, no API key, OpenStreetMap data). MapLibre
/// shows the required attribution itself, so keep `attributionEnabled`.
const _mapStyle = MapLibreStyles.openfreemapLiberty;

/// Sets the home address, used for doctor search when the current position
/// is not shared. Two ways: move the map under the pin (or tap the map), or
/// "Use my current location". The name comes from reverse geocoding on the
/// device and is saved in `personal_info.fallbackLocation*`.
///
/// Pops with the saved [FallbackLocation], or nothing when the user leaves
/// without saving (or removes it).
class HomeLocationScreen extends StatefulWidget {
  const HomeLocationScreen({
    super.key,
    this.location = const LocationService(),
  });

  final LocationService location;

  @override
  State<HomeLocationScreen> createState() => _HomeLocationScreenState();
}

class _HomeLocationScreenState extends State<HomeLocationScreen>
    with WidgetsBindingObserver {
  static const _zoom = 15.5;

  /// Saved home, loaded once. Null when none is saved.
  FallbackLocation? _saved;
  bool _loadStarted = false;

  /// [_point] and [_saved] are loaded; the map can be created.
  bool _ready = false;

  MapLibreMapController? _map;
  late ({double latitude, double longitude}) _point;

  PlaceNames? _names;
  bool _resolving = false;
  int _resolveRun = 0;
  Timer? _resolveDelay;

  bool _locating = false;
  bool _saving = false;
  LocationAccess? _access;

  LocationService get _location => widget.location;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshAccess();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadStarted) _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _resolveDelay?.cancel();
    super.dispose();
  }

  /// Back from the system settings: the permission may have changed.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshAccess();
  }

  Future<void> _load() async {
    _loadStarted = true;
    final info = await RepositoriesScope.of(context).personalInfo.get();
    final saved = info.fallbackLocation;
    if (!mounted) return;
    setState(() {
      _saved = saved;
      _point = saved == null
          ? kosiceCentre
          : (latitude: saved.latitude, longitude: saved.longitude);
      _names = saved == null
          ? null
          : PlaceNames(address: saved.label, area: null);
      _ready = true;
    });
    if (saved == null) _resolve();
  }

  Future<void> _refreshAccess() async {
    final access = await _location.access();
    if (mounted) setState(() => _access = access);
  }

  // ---------------------------------------------------------------------------
  // Map
  // ---------------------------------------------------------------------------

  void _onCameraIdle() {
    final target = _map?.cameraPosition?.target;
    if (target == null) return;
    final moved = (target.latitude - _point.latitude).abs() > 1e-6 ||
        (target.longitude - _point.longitude).abs() > 1e-6;
    if (!moved) return;
    setState(() {
      _point = (latitude: target.latitude, longitude: target.longitude);
      _names = null;
    });
    // Geocode once the map rests, not on every small move.
    _resolveDelay?.cancel();
    _resolveDelay = Timer(const Duration(milliseconds: 400), _resolve);
  }

  void _onMapClick(Point<double> _, LatLng coordinates) {
    _map?.animateCamera(CameraUpdate.newLatLng(coordinates));
  }

  Future<void> _resolve() async {
    final run = ++_resolveRun;
    final point = _point;
    setState(() => _resolving = true);
    final names = await _location.placeNames(point.latitude, point.longitude);
    // A newer move started another lookup; this answer is outdated.
    if (!mounted || run != _resolveRun) return;
    setState(() {
      _names = names;
      _resolving = false;
    });
  }

  Future<void> _useCurrentPosition() async {
    setState(() => _locating = true);
    final result = await _location.currentPosition();
    if (!mounted) return;
    setState(() => _locating = false);
    _refreshAccess();

    switch (result) {
      case PositionFound(:final latitude, :final longitude):
        await _map?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), _zoom),
        );
      case PositionFailed(:final problem):
        showLocationProblem(context, problem, _location);
    }
  }

  // ---------------------------------------------------------------------------
  // Saving
  // ---------------------------------------------------------------------------

  Future<void> _save() async {
    final point = _point;
    final home = FallbackLocation(
      label: _names?.address ??
          formatCoordinates(point.latitude, point.longitude),
      latitude: point.latitude,
      longitude: point.longitude,
    );
    await _write(home);
    if (mounted) context.pop(home);
  }

  Future<void> _remove() async {
    await _write(null);
    if (mounted) context.pop();
  }

  Future<void> _write(FallbackLocation? home) async {
    setState(() => _saving = true);
    try {
      final repository = RepositoriesScope.of(context).personalInfo;
      final info = await repository.get();
      await repository.save(info.copyWith(fallbackLocation: home));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeader(title: 'Home address'),
            Expanded(
              child: _ready
                  ? _buildMap()
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.colorBrand,
                      ),
                    ),
            ),
            if (_ready) _buildPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        Positioned.fill(
          child: MapLibreMap(
            styleString: _mapStyle,
            initialCameraPosition: CameraPosition(
              target: LatLng(_point.latitude, _point.longitude),
              zoom: _zoom,
            ),
            trackCameraPosition: true,
            onMapCreated: (controller) => _map = controller,
            onCameraIdle: _onCameraIdle,
            onMapClick: _onMapClick,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            compassEnabled: false,
            // Required: OpenFreeMap / OpenMapTiles / OpenStreetMap credits.
            attributionEnabled: true,
          ),
        ),
        // The pin stays in the middle; the map moves under it.
        const IgnorePointer(
          child: Center(
            child: Padding(
              // Lifts the icon so its tip, not its centre, marks the point.
              padding: EdgeInsets.only(bottom: 40),
              child: Icon(
                Icons.location_on,
                size: 44,
                color: AppColors.colorBrand,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPanel() {
    final names = _names;
    final address = names?.address ??
        (_resolving
            ? 'Finding the address…'
            : formatCoordinates(_point.latitude, _point.longitude));

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.l,
        AppSpacing.screen,
        AppSpacing.l,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x146D5085),
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.m,
        children: [
          Text(
            'Move the map so the pin is on your home, or use your current location.',
            style: AppTextStyles.meta,
          ),
          Row(
            spacing: AppSpacing.s,
            children: [
              const Icon(Icons.home_outlined, size: 20, color: AppColors.colorBrand),
              Expanded(
                child: Text(
                  address,
                  style: AppTextStyles.detailStrong,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppButton(
            variant: AppButtonVariant.soft,
            leading: _locating
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.colorPressed,
                    ),
                  )
                : const Icon(Icons.my_location),
            expanded: true,
            onTap: _locating || _saving ? null : _useCurrentPosition,
            child: const Text('Use my current location'),
          ),
          AppButton.text(
            'Save home address',
            size: AppButtonSize.large,
            expanded: true,
            onTap: _saving || _resolving ? null : _save,
          ),
          if (_saved != null)
            AppButton.text(
              'Remove home address',
              variant: AppButtonVariant.soft,
              size: AppButtonSize.small,
              backgroundColor: Colors.transparent,
              foregroundColor: AppColors.secondaryText,
              onTap: _saving ? null : _remove,
            ),
          _AccessRow(access: _access, location: _location),
        ],
      ),
    );
  }
}

/// "Location access: …" with a shortcut to the system settings, like the
/// permission rows in other apps. The app itself never changes it.
class _AccessRow extends StatelessWidget {
  const _AccessRow({required this.access, required this.location});

  final LocationAccess? access;
  final LocationService location;

  @override
  Widget build(BuildContext context) {
    final access = this.access;
    if (access == null) return const SizedBox.shrink();

    final (text, action) = switch (access) {
      LocationAccess.allowed => ('Location access: allowed', null),
      LocationAccess.notAsked => (
          'Location access: not allowed yet. The app asks when you use it.',
          null,
        ),
      LocationAccess.deniedForever =>
        ('Location access: blocked', location.openAppSettings),
      LocationAccess.serviceDisabled => (
          'Location is off on this device',
          location.openLocationSettings,
        ),
    };

    return Row(
      spacing: AppSpacing.s,
      children: [
        Expanded(child: Text(text, style: AppTextStyles.caption)),
        if (action != null)
          AppButton.text(
            'Settings',
            variant: AppButtonVariant.soft,
            size: AppButtonSize.small,
            onTap: action,
          ),
      ],
    );
  }
}
