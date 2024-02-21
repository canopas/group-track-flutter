import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

StateProvider<T> createPrefProvider<T>({
  required String prefKey,
  required T defaultValue,
}) {
  return StateProvider((ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final currentValue = prefs.get(prefKey) as T? ?? defaultValue;
    ref.listenSelf((prev, curr) {
      if (curr == null) {
        prefs.remove(prefKey);
      } else if (curr is String) {
        prefs.setString(prefKey, curr);
      } else if (curr is bool) {
        prefs.setBool(prefKey, curr);
      } else if (curr is int) {
        prefs.setInt(prefKey, curr);
      } else if (curr is double) {
        prefs.setDouble(prefKey, curr);
      } else if (curr is List<String>) {
        prefs.setStringList(prefKey, curr);
      }
    });
    return currentValue;
  });
}
