import 'package:flutter/material.dart';
import 'package:mobile/consts.dart';

class MyPadding extends Padding {
  const MyPadding({super.key, required super.child}): super(padding: defaultPadding);
}

class MyText extends Text {
  const MyText(super.data, {super.key}): super(style: defaulTextStyle);
}

stringNotEmptyValidator(value, message){
  if (value == null || value.trim().isEmpty) {
    return message;
  }
  return null;
}

showNetworkErrorDialog(context, {message}) =>
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      content: MyText(message ?? 'Error while communicating with the server'),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const MyText('OK'))
      ],
    ));