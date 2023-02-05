import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  //keys
  static const String userLoggedInKey = 'LOGGEDINKEY';
  static const String userNameKey = 'USERNAMEKEY';
  static const String userEmailKey = 'USEREMAILKEY';

// write data to SF

//read data to SF

  static Future<bool?> getUserAuthStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
}
