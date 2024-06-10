import 'package:flutter/material.dart';
import 'package:mobile/Adds/PasswordField.dart';
import 'package:mobile/components.dart';
import 'package:mobile/consts.dart';
import 'package:mobile/pages/MyHomePage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:mobile/services/UserRoutes.dart';
import 'package:mobile/model/User.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:provider/provider.dart';

class SigninPage extends StatefulWidget {
  SigninPage({super.key});
  final userRoutes = UserRoutes();

  @override
  State<StatefulWidget> createState() => _Signinpage();
}

class _Signinpage extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _login;
  late String _password;
  String? _loginError;
  var processSignin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Inscription'),
      ),
      body: SingleChildScrollView( // Ajout de SingleChildScrollView
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ pour le login
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Identifiant',
                    errorText: _loginError,
                    icon: Icon(Icons.person),
                  ),
                  style: defaulTextStyle,
                  validator: (value) => stringNotEmptyValidator(value, 'Entrez votre identifiant'),
                  maxLength: 25, // Limite de caractères
                  onSaved: (value) => _login = value.toString(),
                ),
                // Champ pour le Password
                PasswordField(
                  defaulTextStyle: defaulTextStyle,
                  validator: (value) {
                    String? error = stringNotEmptyValidator(value, 'Entrez votre mot de passe');
                    if (error != null) {
                      return error;
                    }
                    error = verifyLengthValidator(value);
                    if (error != null) {
                      return error;
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value.toString(),
                  onChanged: (value) => _password = value,
                ),
                // Champ pour la vérification Password
                PasswordField(
                  defaulTextStyle: defaulTextStyle,
                  validator: (value) {
                    if (value != _password) {
                      return 'Mot de passe différent';
                    }
                    if (value == null || value.trim().isEmpty) {
                      return 'Entrez votre mot de passe';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                if (processSignin)
                  const Center(child: MyPadding(child: CircularProgressIndicator()))
                else
                // Bouton pour Sign in
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _signup(),
                        child: const Text("S'enregistrer"),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signup() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState?.save();

    _loginError = null;
    try {
      setState(() {
        processSignin = true;
      });
      // On insert le User en db puis renvoie à la LoginPage
      widget.userRoutes.insert(User(login: _login, password: _password))
          .then((result_insert) {
        if (result_insert == 402) {
          setState(() {
            _loginError = 'Identifiant déjà utilisé';
            processSignin = false;
          });
        } else {
          widget.userRoutes.authenticate(_login, _password).then((authResult) {
            Provider.of<LoginState>(context, listen: false).setToken(authResult.token);
            Provider.of<LoginState>(context, listen: false).setUser(User(login: _login, password: _password));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) => false,
            );

          });
        }
      });
    } catch (error) {
      showNetworkErrorDialog(context);
    }
  }
}
