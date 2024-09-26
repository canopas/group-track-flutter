import 'package:flutter/cupertino.dart';
import 'package:style/animation/on_tap_scale.dart';

class NoInternetScreen extends StatelessWidget {
  final Function()? onPressed;

  const NoInternetScreen({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: OnTapScale(onTap: onPressed, child: const Text("No internet")));
  }
}
