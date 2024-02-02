import 'package:mobile/model/User.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'MyAPI.dart';

class LoginState extends ChangeNotifier{
  User? _user;
  String? _token;



  bool connected(){
    if (_user != null){
      return true;
    }
    return false;
  }

  LoginState() {
    final validity = verifyTokenValidity();
    SharedPreferences.getInstance().then((prefs) {
      final login = prefs.getString('login');
      final token = prefs.getString('token');
      if ((login != null) && (token != null)) {
        _user = User(login: login);
        _token = token;
        notifyListeners();
      }
    });
  }


  Future<bool> verifyTokenValidity() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if ( token != null) {
      _token = token;

      try {
        // Envoyer une requête à l'API pour vérifier la validité du token
        final response = await http.get(
          Uri.http(MyAPI.apiServ, '/verifyToken'),
          headers: {'Authorization': 'Bearer $_token'},
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

  User getUser(){
    return _user!;
  }

  setUser(User user){
    _user = user;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("login", user!.login);
    });
  }

  String getToken(){
    return _token!;
  }

  setToken(String token){
    _token = token;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("token", _token!);
    });
  }

  disconnected(){
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("login");
      prefs.remove("token");
    });
    _user = null;
    _token = null;
    notifyListeners();
  }


}