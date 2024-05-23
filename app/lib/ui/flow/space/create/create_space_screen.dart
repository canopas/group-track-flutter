import 'package:flutter/cupertino.dart';
import 'package:yourspace_flutter/ui/components/app_page.dart';

class CreateSpace extends StatefulWidget {
  const CreateSpace({super.key});

  @override
  State<CreateSpace> createState() => _CreateSpaceState();
}

class _CreateSpaceState extends State<CreateSpace> {
  @override
  Widget build(BuildContext context) {
    return const AppPage(body: Text('create space'));
  }
}
