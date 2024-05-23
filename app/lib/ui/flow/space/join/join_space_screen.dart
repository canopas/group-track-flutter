
import 'package:flutter/cupertino.dart';

import '../../../components/app_page.dart';

class JoinSpace extends StatefulWidget {
  const JoinSpace({super.key});

  @override
  State<JoinSpace> createState() => _JoinSpaceState();
}

class _JoinSpaceState extends State<JoinSpace> {
  @override
  Widget build(BuildContext context) {
    return const AppPage(body: Text('join space'));
  }
}
