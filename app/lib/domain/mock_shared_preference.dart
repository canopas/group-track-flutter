import 'package:data/storage/preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferencesNotifier extends SharedPreferencesNotifier {
  final SharedPreferences mockPrefs;

  MockSharedPreferencesNotifier(this.mockPrefs);

  @override
  SharedPreferences build() => mockPrefs;
}