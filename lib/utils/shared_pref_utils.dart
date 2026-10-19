import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  PrefKeys._();

  static const String languageCode = 'language_code';
  static const String userId = 'user_id';
  static const String isOnboardingSeen = 'is_onboarding_seen';
}

class SharedPrefUtils {
  SharedPrefUtils._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('SharedPrefUtils is not initialized.');
    }
    return prefs;
  }

  static String? get languageCode {
    final code = _instance.getString(PrefKeys.languageCode);
    if (code == 'ar' || code == 'en') return code;
    return null ;
  }

  static Future<bool> saveLanguageCode(String code) {
    if (code != 'ar' && code != 'en') return Future.value(false);
    return _instance.setString(PrefKeys.languageCode, code);
  }

  static String? get userId => _instance.getString(PrefKeys.userId);

  static Future<bool> saveUserId(String uid) =>
      _instance.setString(PrefKeys.userId, uid);

  static Future<bool> removeUserId() =>
      _instance.remove(PrefKeys.userId);

  static bool get isOnboardingSeen =>
      _instance.getBool(PrefKeys.isOnboardingSeen) ?? false;

  static Future<bool> saveOnboardingSeen(bool isSeen) =>
      _instance.setBool(PrefKeys.isOnboardingSeen, isSeen);
}
