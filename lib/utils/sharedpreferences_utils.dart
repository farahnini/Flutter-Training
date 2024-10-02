import 'package:shared_preferences/shared_preferences.dart';


class SharedpreferencesUtils {
  
  static SharedPreferences storageUtils = SharedPreferences.getInstance() as SharedPreferences;

  init() async
  {
    storageUtils = await SharedPreferences.getInstance();
  }

  String get getStorageToken => storageUtils.getString('user_token') ?? '';

  String get getStorageUserName => storageUtils.getString('user_name').toString();

  String get getStorageUserUuid => storageUtils.getString('user_uuid').toString();

  String get getStorageUserPlayerId => storageUtils.getString('user_playerId').toString();

  String get getStorageDevice => storageUtils.getString('device').toString();

  set setSharedPrefsToken(String value){
    storageUtils.setString('user_token', value);
  }

  set setSharedPrefsUserName(String value){
    storageUtils.setString('user_name', value);
  }

  set setSharedUserUuid(String value){
    storageUtils.setString('user_uuid', value);
  }

  // Ambil user punya subcription ID
  set setSharedUserPlayerId(String value){
    storageUtils.setString('user_playerId', value);
  }

  set setSharedPrefsDevice(String value) {
    storageUtils.setString('device', value);
  }

  clearStorage(){
    storageUtils.clear();
  }
  
}