import "package:mobile/components.dart";
import 'package:flutter/material.dart';
import 'package:mobile/Adds/ExercicePageButton.dart';

class ExercicePageButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ExercicePageButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0, // Ajustez la largeur selon vos besoins
      child: MyPadding(
        child: ElevatedButton(
          onPressed: onPressed,
          child: const MyText('Exerices'), // Ajustez la taille de la police selon vos besoins
        ),
      ),
    );
  }
}