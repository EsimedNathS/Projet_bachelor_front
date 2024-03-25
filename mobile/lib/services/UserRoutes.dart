import 'dart:developer';

import 'package:mobile/model/User.dart';
import 'package:mobile/services/MyAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/model/AuthenticationResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRoutes extends MyAPI {
  static const userRoutes = '/user';

  Future insert(User user) async {
    var data = jsonEncode(user);
    var result = await http.post(
        Uri.http(MyAPI.apiServ, '$userRoutes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
  }

  Future search(String login) async {
    var result = await http.get(
        Uri.http(MyAPI.apiServ, '$userRoutes/$login'));
    return result.statusCode == 200;
  }


  Future<AuthenticationResult> authenticate(String login, String password) async {
    var data = jsonEncode({ 'login' : login, 'password' : password});
    var result = await http.post(Uri.http(MyAPI.apiServ, '$userRoutes/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    final Map<String, dynamic> datas = jsonDecode(result.body);
    return AuthenticationResult.fromMap(datas);
  }

  Future<bool> verifyTokenValidity() async {
    var prefs =  await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if ( token != null) {

      try {
        // Envoyer une requête à l'API pour vérifier la validité du token
        final response = await http.get(
          Uri.http(MyAPI.apiServ, '/verifyToken'),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode != 200) {
          return false;
        } else {
          return true;
        }
      } catch (error) {
        print('Erreur lors de la vérification du token: $error');
      }
    }
    return false;
  }


}