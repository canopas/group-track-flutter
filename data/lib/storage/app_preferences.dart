import 'package:data/storage/preferences_provider.dart';

final isIntroScreenShownPod = createPrefProvider<bool>(
  prefKey: "show_intro_screen",
  defaultValue: false,
);
