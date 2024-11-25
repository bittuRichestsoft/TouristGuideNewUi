import 'package:Siesta/app_constants/shared_preferences.dart';

class AuthServices {
  // Token
  static Future<String> getAuthBearerToken([String? token]) async {
    return SharedPreferenceValues.token.toString();
  }
}
