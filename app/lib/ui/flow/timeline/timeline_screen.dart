import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Timeline',
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container();
  }
}
