import 'package:flutter/cupertino.dart';

class OnVisibleCallback extends StatefulWidget {
  final void Function() onVisible;
  final Widget child;

  const OnVisibleCallback({
    super.key,
    required this.onVisible,
    required this.child,
  });

  @override
  State<OnVisibleCallback> createState() => _OnCreateState();
}

class _OnCreateState extends State<OnVisibleCallback> {
  @override
  void initState() {
    widget.onVisible();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
