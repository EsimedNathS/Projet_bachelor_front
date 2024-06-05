import 'package:flutter/material.dart';
import 'package:mobile/pages/ProgrammePage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:provider/provider.dart';

ChangeNameDialog(BuildContext context, programmeRoutes, programme_id, {String? message}) => showDialog(
  context: context,
  builder: (BuildContext context) {
    String newProgramName = ''; // Variable pour stocker le nom du programme

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nouveau nom du programme:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Augmenter la taille du texte
            ),
          ),
          TextField(
            onChanged: (value) {
              newProgramName = value; // Mettre à jour le nom du programme lorsque l'utilisateur tape
            },
            decoration: InputDecoration(
              hintText: 'Entrez le nom ici',
              counterText: '', // Cache le compteur de caractères par défaut
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
            Spacer(), // Ajoute un espace flexible entre les boutons
            ElevatedButton(
              onPressed: () {
                var token = Provider.of<LoginState>(context, listen: false).getToken();
                programmeRoutes.patchProg(token, programme_id, "name", newProgramName).then((result_prog) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProgrammePage()));
                });
              },
              child: const Text('OK', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ],
    );
  },
);
