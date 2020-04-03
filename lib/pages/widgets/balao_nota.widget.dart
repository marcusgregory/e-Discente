import 'package:flutter/material.dart';

class BalaoNota extends StatelessWidget {
  final String nota;
  const BalaoNota(this.nota);
  @override
  Widget build(BuildContext context) {
   return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            color: (nota.isEmpty || nota.contains('-'))
                ? Colors.grey
                : double.parse(nota.replaceAll(",", ".")) >= 7
                    ? Colors.green[400]
                    : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        Text(nota,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }
}