import 'package:flutter/widgets.dart';

/// Reports its child's size after layout, and again whenever it changes.
class MeasureSize extends StatefulWidget {
  const MeasureSize({super.key, required this.onChange, required this.child});

  final ValueChanged<Size> onChange;
  final Widget child;

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  Size? _last;

  @override
  void initState() {
    super.initState();
    _report();
  }

  void _report() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final size = context.size;
      if (size == null || size == _last) return;
      _last = size;
      widget.onChange(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _report();
        return true;
      },
      child: SizeChangedLayoutNotifier(child: widget.child),
    );
  }
}