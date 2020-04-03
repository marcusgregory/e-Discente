import 'package:flutter/material.dart';

class BalaoSituacao extends StatelessWidget {
  final String situacao;
  const BalaoSituacao(this.situacao);
  @override
  Widget build(BuildContext context) {
   return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: (situacao.isEmpty || situacao.contains('-'))
                ? Colors.grey
                : situacao.contains('APR')
                    ? Colors.green[400]
                    : Colors.orange,
            shape: BoxShape.circle,
          ),
        ),
        Text(situacao,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }
}