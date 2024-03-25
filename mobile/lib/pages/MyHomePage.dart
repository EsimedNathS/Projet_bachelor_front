import 'package:mobile/components.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/Adds/LogoutButton.dart';
import 'package:mobile/Adds/ExercicePageButton.dart';
import 'package:mobile/pages/ExercicePage.dart';


class MyHomePage extends StatefulWidget{

  @override
  State<MyHomePage> createState() => MyHomePageState();

}

class MyHomePageState extends State<MyHomePage> {
  String title = "Date ouf Today";

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
        ],
      ),
    );
  }
}
