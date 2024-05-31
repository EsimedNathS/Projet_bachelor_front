import 'package:mobile/components.dart';
import 'package:mobile/model/Programme.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/ProgrammeRoutes.dart';
import 'package:provider/provider.dart';
import 'package:mobile/Adds/LogoutButton.dart';
import 'package:mobile/Adds/ExercicePageButton.dart';
import 'package:mobile/pages/ExercicePage.dart';
import 'package:mobile/Adds/ProgrammePageButton.dart';
import 'ProgrammePage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class MyHomePage extends StatefulWidget{
  final programmeRoutes = ProgrammeRoutes();

  @override
  State<MyHomePage> createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage> {
  String title = "Date ouf Today";
  dynamic? programme;
  bool dataLoaded = false;

  MyHomePageState() {
    title = obtenirDateDuJour();
  }

  @override
  void initState() {
    super.initState();
    getprog();
  }

  getprog() {
    Provider.of<LoginState>(context, listen: false);
    DateTime aujourdHui = DateTime.now();
    String jourAujourdhui = DateFormat('EEEE', 'fr').format(aujourdHui);
    widget.programmeRoutes
        .getAll(Provider.of<LoginState>(context, listen: false))
        .then((values) {
          values.forEach((value) {
            if (value['day'].toLowerCase() == jourAujourdhui) {
              programme = value;
            }
          });
          setState(() {
            dataLoaded = true;
          });
        });
  }

  String obtenirDateDuJour() {
    initializeDateFormatting('fr');
    DateTime maintenant = DateTime.now();
    String dateFormatee = DateFormat('EEEE d MMMM', 'fr').format(maintenant);
    String dateFormateeMajuscule = dateFormatee[0].toUpperCase() + dateFormatee.substring(1);

    return dateFormateeMajuscule;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Barre du haut avec date et Log out
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          LogoutButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          }),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Contenu de la page
          FutureBuilder(
            future: Future.value(dataLoaded),
            builder: (context, snapshot) {
              if (!dataLoaded) { // Si données non chargées
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Affichage du programme du jour
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: programme != null
                          ? Text(
                        'Programme du jour: ${programme['name']}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )
                          : Text(
                        'Pas de programme prévu pour aujourd\'hui',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Liste des exercices
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (programme != null && programme['exercice'] != null)
                              ...programme['exercice'].map<Widget>((exercice) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0), // Augmenter l'espace vertical
                                  child: Text(
                                    exercice['name'],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ),
                    // Boutons en bas de la page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ExercicePageButton(
                            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ExercicePage())),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ProgrammePageButton(
                            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProgrammePage())),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
          // Bouton en bas à gauche
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ExercicePageButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => ExercicePage())),
              ),
            ),
          ),
          // Bouton en bas à droite
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ProgrammePageButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => ProgrammePage())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
