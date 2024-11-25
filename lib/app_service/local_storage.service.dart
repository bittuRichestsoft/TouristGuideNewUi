import 'package:Siesta/app_constants/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{
  getSessionId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString(SharedPreferenceValues.token);
    if(stringValue==null){
      return "";
    }
    return stringValue;
  }

  setSessionId(String token,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferenceValues.token, token);

  }
}