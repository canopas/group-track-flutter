import 'package:flutter/widgets.dart';

void runPostFrame(Function() block) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    block();
  });
}
