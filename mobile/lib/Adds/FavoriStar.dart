import 'package:flutter/material.dart';
import 'package:mobile/services/ExerciceRoutes.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:provider/provider.dart';

Widget FavoriStar(Map<String, dynamic> item, {ExerciceRoutes? exerciceRoutes, ProgrammeRoutes? programmeRoutes, required BuildContext context, required Function setStateCallback}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          var token = Provider.of<LoginState>(context, listen: false).getToken();
          if (exerciceRoutes != null){
            if (!item['isFavourite']){
              exerciceRoutes?.addFavori(token, int.parse(item['id']))
                  .then( (_) => setStateCallback(() {
                item['isFavourite'] = !item['isFavourite'];
              })
              );
            } else {
              exerciceRoutes?.removeFavori(token, int.parse(item['id']))
                  .then( (_) => setStateCallback(() {
                item['isFavourite'] = !item['isFavourite'];
              })
              );
            }
          }
          else {
            programmeRoutes?.patchProg(token, item['id'], 'favori', !item['favori'])
                  .then( (_) => setStateCallback(() {
                    item['favori'] = !item['favori'];
                  })
              );
          }
        },
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: exerciceRoutes != null ? (item['isFavourite'] ? 1.0 : 0.0) : (item['favori'] ? 1.0 : 0.0),
              child: Icon(
                Icons.star,
                color: Colors.red,
                size: 25.0,
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: exerciceRoutes != null ? (item['isFavourite'] ? 0.0 : 1.0) : (item['favori'] ? 0.0 : 1.0), // Cacher l'étoile lorsque non remplie
              child: Icon(
                Icons.star_border,
                color: Colors.black,
                size: 25.0,
              ),
            ),
          ],
        ),
      ),

      if (exerciceRoutes != null) ...[
        SizedBox(width: 10), // Espacement entre l'icône et le texte
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4), // Espacement entre le nom et la description
              Text(
                item['description'],
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Spécifie le nombre maximum de lignes pour la description
              ),
            ],
          ),
        ),
      ],



    ],
  );
}
