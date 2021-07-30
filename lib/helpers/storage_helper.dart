
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<void> setFirstTime(bool isFirstTime)  async {}
  SharedPreferences get prefs => _prefs as SharedPreferences;
}