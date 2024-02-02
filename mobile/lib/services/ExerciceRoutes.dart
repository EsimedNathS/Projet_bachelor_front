import 'package:mobile/services/MyAPI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciceRoutes extends MyAPI {
  static const userRoutes = '/exercice';


  Future getAll() async {
    var result = await http.get(
      Uri.http(MyAPI.apiServ, '$userRoutes'),
    );
    List<dynamic> jsonData = jsonDecode(result.body);

    final TopPoly = <dynamic>[];
    final TopIso = <dynamic>[];
    final BottomPoly = <dynamic>[];
    final BottomIso = <dynamic>[];

    for (var i = 0; i < jsonData.length; i++) {
      var data = jsonData[i];

      // Accéder aux valeurs correctement en utilisant les clés
      String? groupe = data['groupe'];
      String? type = data['type'];

      if (groupe == "Top" && type == "Polymusculaire") {
        // Faire quelque chose avec les données Top/Polymusculaire
        TopPoly.add(data);
      }

      if (groupe == "Top" && type == "Isolation") {
        // Faire quelque chose avec les données Top/Isométrique
        TopIso.add(data);
      }

      if (groupe == "Bottom" && type == "Polymusculaire") {
        // Faire quelque chose avec les données Bottom/Polymusculaire
        BottomPoly.add(data);
      }

      if (groupe == "Bottom" && type == "Isolation") {
        // Faire quelque chose avec les données Bottom/Isométrique
        BottomIso.add(data);
      }
    }

    result.statusCode == 200;
    return  [TopPoly, TopIso, BottomPoly, BottomIso];
  }



}