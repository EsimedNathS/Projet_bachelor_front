import 'package:mobile/services/MyAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LoginState.dart';

class ExerciceRoutes extends MyAPI {
  static const userRoutes = '/exercice';


  Future getAll(LoginState loginState) async {
    var token = loginState.getToken();
    var result = await http.get(
      Uri.https(MyAPI.apiServ, '$userRoutes'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (result.statusCode == 401) {
      // TODO faire un truc en cas d'erreur
    }
    List<dynamic> result_jsonData = jsonDecode(result.body);


    var result_fav = await http.get(
      Uri.https(MyAPI.apiServ, '$userRoutes/favori'),
      headers: {'Authorization': 'Bearer $token'},
    );
    List<dynamic> result_fav_jsonData = jsonDecode(result_fav.body);


    final TopPoly = <dynamic>[];
    final TopIso = <dynamic>[];
    final BottomPoly = <dynamic>[];
    final BottomIso = <dynamic>[];

    for (var i = 0; i < result_jsonData.length; i++) {
      var data = result_jsonData[i];

      // Accéder aux valeurs correctement en utilisant les clés
      String? groupe = data['groupe'];
      String? type = data['type'];

      // Vérifie si data['id'] est contenu dans result_fav
      bool isFavourite = false;
      for (var favData in result_fav_jsonData) {
        if (favData['id'] == data['id']) {
          isFavourite = true;
          break;
        }
      }

      if (groupe == "Top" && type == "Polymusculaire") {
        TopPoly.add({...data, 'isFavourite': isFavourite});
      }

      if (groupe == "Top" && type == "Isolation") {
        TopIso.add({...data, 'isFavourite': isFavourite});
      }

      if (groupe == "Bottom" && type == "Polymusculaire") {
        BottomPoly.add({...data, 'isFavourite': isFavourite});
      }

      if (groupe == "Bottom" && type == "Isolation") {
        BottomIso.add({...data, 'isFavourite': isFavourite});
      }
    }

    result.statusCode == 200;
    return  [TopPoly, TopIso, BottomPoly, BottomIso];
  }

  Future getAllFavori(LoginState loginState) async {
    var token = loginState.getToken();

    var result_fav = await http.get(
      Uri.https(MyAPI.apiServ, '$userRoutes/favori'),
      headers: {'Authorization': 'Bearer $token'},
    );
    List<dynamic> result_fav_data = jsonDecode(result_fav.body);

    result_fav.statusCode == 200;
    return  result_fav_data;
  }

  Future addFavori(String token, int exercice_id) async {
    Map<String, dynamic> values = {
      'exercice_id': exercice_id,
    };
    var data = jsonEncode(values);
    var result = await http.post(
        Uri.https(MyAPI.apiServ, '$userRoutes/favori'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
        },
      body: data
    );
    if (result.statusCode == 401) {
      // TODO faire un truc en cas d'erreur
    }
    result.statusCode == 200;
    return result.statusCode;
  }

  Future removeFavori(String token, int exercice_id) async {
    Map<String, dynamic> values = {
      'exercice_id': exercice_id,
    };
    var data = jsonEncode(values);
    var result = await http.delete(
        Uri.https(MyAPI.apiServ, '$userRoutes/favori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: data
    );
    if (result.statusCode == 401) {
      // TODO faire un truc en cas d'erreur
    }
    result.statusCode == 200;
    return result.statusCode;
  }



}