import 'dart:developer';

import 'package:mobile/components.dart';
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
    if (result.statusCode == 402) {
      return 402;
    }
    if (result.statusCode == 500) {
      throw NetworkException();
    }
  }

  Future delete(token) async {
    var result = await http.delete(
      Uri.http(MyAPI.apiServ, '$userRoutes'),
        headers: {'Authorization': 'Bearer $token'},
    );
    if (result.statusCode == 402) {
      return 402;
    }
    if (result.statusCode == 500) {
      throw NetworkException();
    }
  }

  Future<AuthenticationResult> authenticate(String login, String password) async {
    var data = jsonEncode({ 'login' : login, 'password' : password});
    var result = await http.post(Uri.http(MyAPI.apiServ, '$userRoutes/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);
    if (result.statusCode == 500) {
      throw NetworkException();
    }
    if (result.statusCode == 401) {
      throw StatusErrorException(401);
    }
    final Map<String, dynamic> datas = jsonDecode(result.body);
    return AuthenticationResult.fromMap(datas);
  }

  Future<int> verifyTokenValidity() async {
    var prefs =  await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    if ( token != null) {

      // Envoyer une requête à l'API pour vérifier la validité du token
      final response = await http.get(
        Uri.http(MyAPI.apiServ, '/verifyToken'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return 1;
      }
      if (response.statusCode == 401) {
        return 2;
      }
      if (response.statusCode == 402) {
        return 3;
      }
      if (response.statusCode == 500) {
        throw NetworkException();
      }
    }
    return 2;
  }


}