import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUsername(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('username', username);
}

Future<String> retrieveUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? username = prefs.getString('username');

  return username ?? "Double tap here to set your username!";
}
