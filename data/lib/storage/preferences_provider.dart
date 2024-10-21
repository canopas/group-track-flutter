import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesNotifier extends Notifier<SharedPreferences> {
  @override
  SharedPreferences build() {
    throw UnimplementedError("Use init() to initialize SharedPreferences.");
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs;
  }
}

final sharedPreferencesProvider =
    NotifierProvider<SharedPreferencesNotifier, SharedPreferences>(
  SharedPreferencesNotifier.new,
);

StateProvider<T> createPrefProvider<T>({
  required String prefKey,
  required T defaultValue,
}) {
  return StateProvider<T>((ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final notifier = ref.read(sharedPreferencesProvider.notifier);

    final currentValue = prefs.get(prefKey) as T? ?? defaultValue;

    notifier.listenSelf((previous, next) {
      _saveToPreferences(prefs, prefKey, next);
    });

    return currentValue;
  });
}

void _saveToPreferences<T>(SharedPreferences prefs, String key, T value) {
  if (value is String) {
    prefs.setString(key, value);
  } else if (value is bool) {
    prefs.setBool(key, value);
  } else if (value is int) {
    prefs.setInt(key, value);
  } else if (value is double) {
    prefs.setDouble(key, value);
  } else if (value is List<String>) {
    prefs.setStringList(key, value);
  } else {
    throw UnsupportedError("Unsupported type: ${T.runtimeType}");
  }
}
