import 'package:flutter/material.dart';

Future<bool> ConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Voulez-vous vraiment supprimer ce programme?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Retourne false si annulé
                },
                child: Text(
                  'Annuler',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Retourne true si confirmé
                },
                child: const Text('OK', style: TextStyle(fontSize: 18)),
              ),
            ],
          )
        ],
      );
    },
  ).then((value) => value ?? false); // Gérer le cas où le dialogue est fermé par d'autres moyens
}
