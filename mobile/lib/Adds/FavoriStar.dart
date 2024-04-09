import 'package:flutter/material.dart';
import 'package:mobile/services/ExerciceRoutes.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:provider/provider.dart';

Widget FavoriStar(Map<String, dynamic> item, ExerciceRoutes exerciceRoutes, BuildContext context, Function setStateCallback) {
  return Row(
    children: [
      GestureDetector(
        onTap: () {
          var token = Provider.of<LoginState>(context, listen: false).getToken();
          if (!item['isFavourite']){
            exerciceRoutes.addFavori(token, int.parse(item['id']))
                .then( (_) => setStateCallback(() {
              item['isFavourite'] = !item['isFavourite'];
            })
            );
          } else {
            exerciceRoutes.removeFavori(token, int.parse(item['id']))
                .then( (_) => setStateCallback(() {
              item['isFavourite'] = !item['isFavourite'];
            })
            );
          }
        },
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: item['isFavourite'] ? 1.0 : 0.0,
              child: Icon(
                Icons.star,
                color: Colors.red,
                size: 25.0,
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: item['isFavourite'] ? 0.0 : 1.0, // Cacher l'étoile lorsque non remplie
              child: Icon(
                Icons.star_border,
                color: Colors.black,
                size: 25.0,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 10), // Espacement entre l'icône et le texte
      Expanded(
        child: Text(item['nameWithDesc']),
      ),
    ],
  );
}
