import 'package:flutter/material.dart';
import 'package:mobile/components.dart';
import 'package:mobile/consts.dart';
import 'package:mobile/services/UserRoutes.dart';
import 'package:mobile/model/User.dart';
import 'package:mobile/pages/LoginPage.dart';


class SigninPage extends StatefulWidget{
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
          title: Text('Sign in'),
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'login',
                          errorText: _loginError
                      ),
                      style: defaulTextStyle,
                      validator: (value) => stringNotEmptyValidator(value, 'Please enter your login'),
                      onSaved: (value) => _login = value.toString(),
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password'
                      ),
                      style: defaulTextStyle,
                      validator: (value) => stringNotEmptyValidator(value, 'Please enter your password'),
                      onChanged: (value) => _password = value.toString(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    TextFormField(
                      style: defaulTextStyle,
                      obscureText: true,
                      decoration: const InputDecoration(
                            labelText: 'Password verif'
                        ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != _password){
                          return 'Not the same password';
                        }
                        if (value == null || value.trim().isEmpty)
                          return 'Please confirm your password';
                      }
                    ),
                    if (processSignin)
                      const Center(child: MyPadding(child: CircularProgressIndicator()))
                    else
                      Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: SizedBox(
                          width : double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _signin(),
                            child: const Text('Sign in'),
                         )
                        )
                      )
                  ],
                )
            )
        )
    );
  }

  _signin() async{
    if ( !_formKey.currentState!.validate() ) return;
    _formKey.currentState?.save();

    _loginError = null;
    try {
      final exists = await widget.userRoutes.search(_login);
      if (exists == true) {
        setState(() {
          _loginError = 'Login already use';
        });
        return ;
      }
    } catch(element) {}

    if (context.mounted) {
      try {
        setState(() {
          processSignin = true;
        });
        await widget.userRoutes.insert(User(login: _login, password: _password));
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } catch (error) {
        showNetworkErrorDialog(context);
      }
    }
  }
}
