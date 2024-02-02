import 'package:mobile/components.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/services/LoginState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget{

  @override
  State<MyHomePage> createState() => _MyHomePage();

}

class _MyHomePage extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Cars'),
      ),
      body: Center(
        child: Consumer<LoginState>(
          builder: (context, loginState, child) =>
          MyText('${loginState.getToken()}'),
        )
      )
    );
  }
}