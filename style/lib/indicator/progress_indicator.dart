import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:style/extenstions/context_extenstions.dart';

const _bufferTimeMillis = Duration(milliseconds: 300);

enum AppProgressIndicatorSize { small, normal }

class AppProgressIndicator extends StatefulWidget {
  final AppProgressIndicatorSize size;
  final Color? color;

  const AppProgressIndicator({
    super.key,
    this.size = AppProgressIndicatorSize.normal,
    this.color,
  });

  @override
  State<AppProgressIndicator> createState() => _AppProgressIndicatorState();
}

class _AppProgressIndicatorState extends State<AppProgressIndicator> {
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_bufferTimeMillis).then((_) {
      if (mounted) {
        setState(() => _showProgress = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _showProgress ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: _indicator(),
    );
  }

  Widget _indicator() {
    final radius = widget.size == AppProgressIndicatorSize.small ? 10.0 : 16.0;

    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        color: widget.color ?? context.colorScheme.primary,
        radius: radius,
      );
    } else {
      return Center(
        child: SizedBox(
          width: radius * 1.8,
          height: radius * 1.8,
          child: CircularProgressIndicator(
            color: widget.color ?? context.colorScheme.primary,
          ),
        ),
      );
    }
  }
}
