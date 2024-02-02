import 'package:mobile/Adds/LoginButton.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components.dart';
import 'package:mobile/consts.dart';
import 'package:mobile/pages/SigninPage.dart';
import 'package:mobile/services/UserRoutes.dart';
import 'package:mobile/model/User.dart';
import 'package:provider/provider.dart';
import 'package:mobile/model/AuthenticationResult.dart';
import 'package:mobile/main.dart';
import '../services/MyAPI.dart';


class LoginPage extends StatefulWidget{
  final userRoutes = UserRoutes();

  @override
  State<LoginPage> createState() => _Loginpage();

}

class _Loginpage extends State<LoginPage>{
  final _formKey = GlobalKey<FormState> ();
  var processLogin = false ;
  late String _login;
  late String _password;
  late Future<AuthenticationResult> _authResult;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
          padding: EdgeInsets.fromLTRB(20, 200, 20, 20),
          child: Column(
             children: [
             Text('Cars',
               style: TextStyle(fontSize: 40),
               textAlign: TextAlign.center,
             ),
             TextFormField(
               decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Login'
               ),
               style: defaulTextStyle,
               validator: (value) => stringNotEmptyValidator(value, 'please enter your login'),
               autofocus: true,
               onSaved: (value) => _login = value.toString(),
             ),
             TextFormField(
               decoration: const InputDecoration(
                 icon: Icon(Icons.lock),
                 labelText: 'Password'
               ),
               style: defaulTextStyle,
               validator: (value) => stringNotEmptyValidator(value, 'please enter your password'),
               onSaved: (value) => _password = value.toString()
             ),
             if (processLogin)
               FutureBuilder(
                   future: _authResult,
                   builder: (context, snapshot) {
                     if (snapshot.hasError) {
                       processLogin = false;
                       final errorMessage = snapshot.error is StatusErrorException ?
                        "Invalid username or password" : "Network error, please try again later";
                       return Column( children: [
                         MyPadding(child: MyText(errorMessage)),
                         LoginButton(onPressed: _dologin)
                       ]);
                     }
                     return Center(child: MyPadding(child: const CircularProgressIndicator()));
                   })
             else
               LoginButton(onPressed: _dologin),
              SizedBox(
                width : double.infinity,
                child: MyPadding(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SigninPage()
                      ));
                    },
                    child: const MyText('Sign in'),
                  )
                )
              )
            ],
           )
          )
        )
      )
    );
  }


  _dologin() async {
    if ( !_formKey.currentState!.validate() ) return;
    _formKey.currentState?.save();
    _authResult = widget.userRoutes.authenticate(_login, _password).then((authResult) {
      Provider.of<LoginState>(context, listen: false).setToken(authResult.token);
      Provider.of<LoginState>(context, listen: false).setUser(User(login: _login, password: _password));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Cars')));
      return _authResult;
    });
    setState(() {
      processLogin = true;
    });
  }

}