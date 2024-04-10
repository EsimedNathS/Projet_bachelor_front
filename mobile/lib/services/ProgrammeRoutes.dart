import 'package:mobile/model/Programme.dart';
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
  final programme_data = jsonDecode(result.body);

  result.statusCode == 200;
  return  programme_data;
  }

  Future insert(token, Programme programme) async {
    var data = jsonEncode(programme);
    var result = await http.post(
        Uri.http(MyAPI.apiServ, '$userRoutes'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    Map<String, dynamic> data_result = jsonDecode(result.body);
    var id_result = data_result['id'];
    return id_result;
  }

  Future delete(token, int programme_id) async {
    var result = await http.delete(
        Uri.http(MyAPI.apiServ, '$userRoutes/$programme_id'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    return result.statusCode;
  }

  Future patchProg(token, id_programme, String champ_patch, dynamic value_patch) async {
    Map<String, dynamic> values = {
      'id_programme' : id_programme,
      'champ_patch' : champ_patch,
      'value_patch' : value_patch,
    };
    var data = jsonEncode(values);
    var result = await http.patch(
        Uri.http(MyAPI.apiServ, '$userRoutes'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data);
    if (result.statusCode == 403) return false;
    if (result.statusCode != 200) throw StatusErrorException(result.statusCode);
    return result.statusCode;
  }

  Future addExercice(token, int programme_id, int exercice_id) async {
    Map<String, dynamic> values = {
      'programme_id': programme_id,
      'exercice_id': exercice_id,
    };
    var data = jsonEncode(values);
    var result = await http.post(
      Uri.http(MyAPI.apiServ, '${userRoutes}/addexercice'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data
    );
    if (result.statusCode == 401) {
      // TODO faire quelque chose en cas d'erreur
    }
    return result.body;
  }

  Future removeExercice(token, int programme_id, int exercice_id) async {
    Map<String, dynamic> values = {
      'programme_id': programme_id,
      'exercice_id': exercice_id,
    };
    var data = jsonEncode(values);
    var result = await http.delete(
        Uri.http(MyAPI.apiServ, '${userRoutes}/removeexercice'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data
    );
    if (result.statusCode == 401) {
      // TODO faire quelque chose en cas d'erreur
    }
    return result.body;
  }
}