import "package:mobile/components.dart";
import 'package:flutter/material.dart';
import 'package:mobile/Adds/ExercicePageButton.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LogoutButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.0, // Ajustez la largeur selon vos besoins
      child: MyPadding(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Icon(
            Icons.logout, // Remplacez "Icons.logout" par l'icône de déconnexion que vous souhaitez utiliser
            size: 24.0, // Ajustez la taille de l'icône selon vos besoins
          ),
        ),
      ),
    );
  }
}