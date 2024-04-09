import 'package:flutter/material.dart';
import 'package:mobile/pages/ProgrammePage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:provider/provider.dart';

ChangeDayDialog(BuildContext context, programmeRoutes, programme_id, {String? message}) => showDialog(
  context: context,
  builder: (BuildContext context) {
    String? _selectedDay;
    bool allocated = false;

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return AlertDialog(
          alignment: Alignment.topCenter,
          title: Text("Choisissez le jour auquel vous voulez associer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (allocated) // Affiche le message d'erreur si allocated est true
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    "Un programme est déjà attribué à ce jour",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Container(
                width: double.maxFinite,
                child: Row(
                  children: [
                    PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: "Lundi",
                            child: Text(
                              "Lundi",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Mardi",
                            child: Text(
                              "Mardi",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Mercredi",
                            child: Text(
                              "Mercredi",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Jeudi",
                            child: Text(
                              "Jeudi",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Vendredi",
                            child: Text(
                              "Vendredi",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Samedi",
                            child: Text(
                              "Samedi",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Dimanche",
                            child: Text(
                              "Dimanche",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: "Aucune",
                            child: Text(
                              "Aucune",
                              style: TextStyle(fontSize: 18), // Ajuster la taille de la police
                            ),
                          ),
                        ];
                      },
                      onSelected: (String value) {
                        setState(() {
                          _selectedDay = value; // Mettre à jour la valeur sélectionnée
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _selectedDay != null ? _selectedDay! : 'Choisir le jour',
                          style: TextStyle(color: _selectedDay != null ? Colors.black : Colors.grey, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                var token = Provider.of<LoginState>(context, listen: false).getToken();
                if (_selectedDay == "Aucune") {
                  _selectedDay = 'null';
                }
                programmeRoutes.patchProg(token, programme_id, "day", _selectedDay).
                then((result_prog) {
                  if (result_prog == false){
                    setState(() {
                      allocated = true;
                    });
                  } else {
                    Navigator.of(context).pop(result_prog);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ProgrammePage()),
                    );
                  }
                });
              },
              child: Text('Valider'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  },
);
