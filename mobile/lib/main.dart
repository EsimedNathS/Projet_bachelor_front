import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:mobile/services/UserRoutes.dart';
import 'package:provider/provider.dart';
import 'package:mobile/components.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginState(),
      lazy: false,
      child: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget{
  final userRoutes = UserRoutes();

  @override
  State<MyApp> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {
  late Future<int> _validity;


  @override
  void initState() {
    _validity = widget.userRoutes.verifyTokenValidity();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: _validity,
          builder: (context, snapshot) {
            // TODO Message d'erreur si y'a pas de data
            if (snapshot.hasError) {
              return LoginPage();
            }
            else {
              if (snapshot.hasData) {
                if (snapshot.data! == 1){
                  return MyHomePage();
                }
                if (snapshot.data! == 2){
                  return LoginPage();
                }
                if (snapshot.data! == 3){
                  return LoginPage(message: "Compte inexistant veuillez en créer un nouveau");
                }
                return LoginPage();
              }
              else {
                return Center(child: MyPadding(child: const CircularProgressIndicator()));
              }
            }
          }
      )
    );
  }
}