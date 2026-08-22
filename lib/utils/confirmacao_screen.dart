import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirmacao {

  static Future<bool> mostrarDialogoConfirmacao(BuildContext context, title, content) async {
    final resultado = await showDialog<bool>(context: context, builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context, false);
          }, child: const Text('Cancelar')),
          TextButton(onPressed: () {
            Navigator.pop(context, true);
          }, child: const Text('Confirmar')),
        ],
      );
    });
    return resultado ?? false;
  }


}