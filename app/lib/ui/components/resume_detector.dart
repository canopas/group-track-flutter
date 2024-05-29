import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ResumeDetector extends StatefulWidget {
  final Function() onResume;
  final Widget child;

  const ResumeDetector({
    super.key,
    required this.onResume,
    required this.child,
  });

  @override
  State<ResumeDetector> createState() => _ResumeDetectorState();
}

class _ResumeDetectorState extends State<ResumeDetector> {
  final String _key = const Uuid().v4();

  var _lastNotifiedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_key),
      child: widget.child,
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          if (DateTime.now().difference(_lastNotifiedTime).inMilliseconds >
              1000) {
            widget.onResume();
            _lastNotifiedTime = DateTime.now();
          }
        }
      },
    );
  }
}
