import "package:mobile/components.dart";
import 'package:flutter/material.dart';

class ProgrammePageButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProgrammePageButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.0, // Ajustez la largeur selon vos besoins
      child: MyPadding(
        child: ElevatedButton(
          onPressed: onPressed,
          child: const MyText('Programmes'), // Ajustez la taille de la police selon vos besoins
        ),
      ),
    );
  }
}