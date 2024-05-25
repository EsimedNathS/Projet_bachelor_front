import 'package:mobile/components.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const LoginButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    //Bouton pour le Log in
    return SizedBox(
        width: double.infinity,
        child:MyPadding(
            child: ElevatedButton(
                onPressed: onPressed,
                child: const MyText('Log in'))
        )
    );
  }
}