import 'package:mobile/Adds/LoginButton.dart';
import 'package:mobile/Adds/ExercicePageButton.dart';
import 'package:mobile/Adds/LogoutButton.dart';
import 'package:mobile/pages/ExercicePage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/consts.dart';
import 'package:mobile/components.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginState(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Consumer<LoginState>(
        builder: (context, validity, child) {
          if (validity == true){
            return MyHomePage(title: 'Voiture');
            //return ExercicePage();
          }
          else
          {
             return LoginPage();
          }
        }
      )
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          LogoutButton(onPressed: () {
            // Mettez ici le code pour gérer la déconnexion, par exemple, la navigation vers la page de connexion
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
