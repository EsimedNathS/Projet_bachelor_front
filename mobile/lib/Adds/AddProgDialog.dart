import 'package:flutter/material.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/pages/ExercicePage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:provider/provider.dart';



AddProgDialog(BuildContext context, programmeRoutes, {String? message}) => showDialog(
  context: context,
  builder: (BuildContext context) {
    String programName = ''; // Variable pour stocker le nom du programme

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nom du nouveau programme:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Augmenter la taille du texte
            ),
          ),
          TextField(
            onChanged: (value) {
              programName = value; // Mettre à jour le nom du programme lorsque l'utilisateur tape
            },
            decoration: InputDecoration(
              hintText: 'Entrez le nom ici',
              counterText: '',
            ),
            maxLength: 40, // Limite de caractères à 40
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: Text(
                'Annuler',
                style: TextStyle(fontSize: 18), // Même taille de police que le bouton "OK"
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Programme programme = Programme(name: programName, day: 'null', favori: false, IDUser: 1);
                var token = Provider.of<LoginState>(context, listen: false).getToken();
                programmeRoutes.insert(token, programme).
                then((result_prog) {
                  programme.id = result_prog;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ExercicePage(programme: programme)));
                });
              },
              child: const Text('OK', style: TextStyle(fontSize: 18)), // Même taille de police que le bouton "Annuler"
            ),
          ],
        )
      ],
    );
  },
);