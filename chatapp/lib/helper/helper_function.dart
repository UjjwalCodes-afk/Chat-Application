import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  //keys
  static String loginkey = "LOGGEDINKEY";
  static String usernamekey = "USERNAMEKEY";
  static String useremailkey = "USEREMAILKEY";

  //saving the data to the SF
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(loginkey, isUserLoggedIn);
  }
  static Future<bool> saveUserNameSf(String userName)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(usernamekey, userName);
  }
  static Future<bool> saveUserEmail(String userEmail)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(useremailkey, userEmail);
  }


  //Getting the data from the SF
  static Future<bool?> getUSerLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(loginkey);
  }
  static Future<String?> getUserEmailFromSf()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(useremailkey);
  }
  static Future<String?> getUserNameFromSf()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(usernamekey);
  }
}