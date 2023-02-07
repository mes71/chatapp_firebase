import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  //keys
  static const String userLoggedInKey = 'LOGGEDINKEY';
  static const String userNameKey = 'USERNAMEKEY';
  static const String userEmailKey = 'USEREMAILKEY';
  static const String userPasswordKey = 'USERPASSWORDKEY';

// write data to SF
  static Future<bool?> setUserAuthStatus(bool hasAuthed) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, hasAuthed);
  }

  static Future<bool?> setUserNameSf(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool?> setUserPasswordSf(String password) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userPasswordKey, password);
  }

  static Future<bool?> setUserEmailSf(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, email);
  }

//read data to SF

  static Future<bool?> getUserAuthStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserNameSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserPasswordSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userPasswordKey);
  }

  static Future<String?> getUserEmailSf() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
}
