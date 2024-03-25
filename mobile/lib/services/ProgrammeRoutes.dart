import 'package:mobile/services/MyAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginState.dart';

class ProgrammeRoutes extends MyAPI {
  static const userRoutes = '/programme';


  Future getAll(LoginState loginState) async {
    var token = loginState.getToken();
    var result = await http.get(
      Uri.http(MyAPI.apiServ, '$userRoutes'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (result.statusCode == 401) {
      // TODO faire un truc en caq d'erreur
    }

    result.statusCode == 200;
    return  true;
  }



}