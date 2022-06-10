import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const String _id = "ID";
  static const String _name = "NAME";
  static const String _idSite = "SITE";
  static const String _idPosition = "POSITION";
  // set
  static void setId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_id, value);
  }

  static void setName(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_name, value);
  }

  static void setIdSite(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_idSite, value);
  }

  static void setIdPosition(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_idPosition, value);
  }

  // get
  static Future<String?> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_id);
  }

  static Future<String?> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }

  static Future<String?> getIdSite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idSite);
  }

  static Future<String?> getIdPosition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idPosition);
  }

  // remove
  static Future<bool> removeName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_name);
  }

  static Future<bool> removeIdSite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_idSite);
  }

  static Future<bool> removeIdPosition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_idPosition);
  }

  //cek
  static Future<bool> checkUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_id);
  }
}
