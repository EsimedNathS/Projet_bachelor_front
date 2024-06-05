import 'package:flutter/material.dart';
import 'package:mobile/Adds/LoginButton.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/components.dart';
import 'package:mobile/consts.dart';
import 'package:mobile/pages/SignUpPage.dart';
import 'package:mobile/services/UserRoutes.dart';
import 'package:mobile/model/User.dart';
import 'package:provider/provider.dart';
import 'package:mobile/model/AuthenticationResult.dart';
import 'package:mobile/pages/MyHomePage.dart';
import '../services/MyAPI.dart';

class LoginPage extends StatefulWidget {
  final userRoutes = UserRoutes();
  final String? message;

  LoginPage({Key? key, this.message}) : super(key: key);

  @override
  State<LoginPage> createState() => _Loginpage();
}

class _Loginpage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var processLogin = false;
  late String _login;
  late String _password;
  late Future<AuthenticationResult> _authResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView( // Ajout de SingleChildScrollView
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centre le contenu verticalement
                children: [
                  SizedBox(height: 100), // Espace supplémentaire en haut pour mieux centrer
                  Text(
                    'Programed',
                    style: TextStyle(fontSize: 40),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20), // Espace entre le titre et le premier champ
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Identifiant',
                    ),
                    style: defaulTextStyle,
                    validator: (value) => stringNotEmptyValidator(value, 'Entrez votre identifiant'),
                    onSaved: (value) => _login = value.toString(),
                    maxLength: 25, // Limite de caractères
                  ),
                  SizedBox(height: 20), // Espace entre les champs
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Mot de passe',
                    ),
                    style: defaulTextStyle,
                    obscureText: true,
                    validator: (value) => stringNotEmptyValidator(value, 'Entrez votre mot de passe'),
                    onSaved: (value) => _password = value.toString(),
                    maxLength: 25, // Limite de caractères
                  ),
                  SizedBox(height: 20), // Espace entre le champ password et le bouton
                  if (processLogin)
                    FutureBuilder(
                      future: _authResult,
                      builder: (context, snapshot) {
                        if (widget.message != null) {
                          processLogin = false;
                          return Column(children: [
                            MyPadding(child: MyText(widget.message!)),
                            LoginButton(onPressed: _dologin),
                          ]);
                        }
                        if (snapshot.hasError) {
                          processLogin = false;
                          final errorMessage = snapshot.error is StatusErrorException
                              ? "Mauvais Identifiant ou Mot de passe"
                              : "Erreur réseau veuillez réessayer plus tard";
                          return Column(children: [
                            MyPadding(child: MyText(errorMessage)),
                            LoginButton(onPressed: _dologin),
                          ]);
                        }
                        return Center(child: MyPadding(child: const CircularProgressIndicator()));
                      },
                    )
                  else
                    LoginButton(onPressed: _dologin),
                  SizedBox(height: 20), // Espace entre le bouton de connexion et le bouton d'inscription
                  SizedBox(
                    width: double.infinity,
                    child: MyPadding(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SigninPage(),
                          ));
                        },
                        child: const MyText("S'inscrire"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _dologin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();
    _authResult = widget.userRoutes.authenticate(_login, _password).then((authResult) {
      Provider.of<LoginState>(context, listen: false).setToken(authResult.token);
      Provider.of<LoginState>(context, listen: false).setUser(User(login: _login, password: _password));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage()));
      return _authResult;
    });
    setState(() {
      processLogin = true;
    });
  }
}
