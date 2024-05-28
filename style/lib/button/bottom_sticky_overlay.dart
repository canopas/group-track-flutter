import 'package:flutter/cupertino.dart';
import 'package:style/extenstions/context_extenstions.dart';

class BottomStickyOverlay extends StatelessWidget {
  static const padding = EdgeInsets.only(bottom: 80);

  final Widget child;

  const BottomStickyOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 16 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  context.colorScheme.surface.withOpacity(0),
                  context.colorScheme.surface,
                  context.colorScheme.surface,
                  context.colorScheme.surface,
                ],
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
