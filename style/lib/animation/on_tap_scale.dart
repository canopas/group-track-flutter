import 'package:flutter/material.dart';

class OnTapScale extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final void Function()? onTap;
  final void Function()? onLongTap;

  const OnTapScale({
    super.key,
    required this.child,
    this.enabled = true,
    this.onTap,
    this.onLongTap,
  });

  @override
  State<OnTapScale> createState() => _OnTapScaleState();
}

class _OnTapScaleState extends State<OnTapScale> with TickerProviderStateMixin {
  double _squareScaleA = 1;

  AnimationController? _animationController;
  DateTime? _downTime;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 1,
      lowerBound: 0.96,
      upperBound: 1,
      duration: const Duration(milliseconds: 100),
    );

    _animationController?.addListener(() {
      setState(() {
        _squareScaleA = _animationController?.value ?? 1;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.enabled) widget.onTap?.call();
      },
      onLongPress: () {
        if (widget.enabled) widget.onLongTap?.call();
      },
      onTapDown: (dp) async {
        if (widget.enabled && widget.onTap != null) {
          _downTime = DateTime.now();
          _animationController?.reverse();
        }
      },
      onTapUp: (dp) {
        onTapUp();
      },
      onTapCancel: () {
        onTapUp();
      },
      child: Transform.scale(
        scale: _squareScaleA,
        child: widget.child,
      ),
    );
  }

  void onTapUp() async {
    if (_downTime != null) {
      final diff = _downTime!
          .add(const Duration(milliseconds: 100))
          .difference(DateTime.now());
      await Future.delayed(diff);
    }
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }
}
