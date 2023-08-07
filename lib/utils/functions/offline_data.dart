import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getOffUsername() async {
  final prefs = await SharedPreferences.getInstance();
  final String? value = prefs.getString('user-name');
  return value;
}

Future<String?> getOffEmail() async {
  final prefs = await SharedPreferences.getInstance();
  final String? value = prefs.getString('user-email');
  return value;
}

Future<String?> getOffProfilePic() async {
  final prefs = await SharedPreferences.getInstance();
  final String? value = prefs.getString('user-pic');
  return value;
}

Future<String?> getOffId() async {
  final prefs = await SharedPreferences.getInstance();
  final String? value = prefs.getString('user-id');
  return value;
}

// Future<Users?> getUserOffline() async {
//   final prefs = await SharedPreferences.getInstance();
//   Users? users;
//   users!.id = prefs.getString('user-id')!;
//   users.nome = prefs.getString('user-name')!;
//   users.imgUrl = prefs.getString('user-pic')!;
//   users.email = prefs.getString('user-email')!;
//   return users;
// }
