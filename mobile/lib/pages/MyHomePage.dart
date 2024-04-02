import 'package:mobile/components.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/Adds/LogoutButton.dart';
import 'package:mobile/Adds/ExercicePageButton.dart';
import 'package:mobile/pages/ExercicePage.dart';
import 'package:mobile/Adds/ProgrammePageButton.dart';
import 'ProgrammePage.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class MyHomePage extends StatefulWidget{

  @override
  State<MyHomePage> createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage> {
  String title = "Date ouf Today";

  MyHomePageState() {
    title = obtenirDateDuJour();
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
      appBar: AppBar(
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText("Liste d'exercice à venir"),
              Consumer<LoginState>(
                builder: (context, loginState, child) =>
                    MyText('Tout va bien'),
              ),
            ],
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
