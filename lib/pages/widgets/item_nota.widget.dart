import 'package:flutter/material.dart';

import 'balao_nota.widget.dart';

class ItemNota extends StatelessWidget {
  final String titulo;
  final String nota;
  final bool left;
  ItemNota(this.titulo, this.nota, {this.left = true});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: left
          ? ListTile(
              leading: BalaoNota(nota),
              title: Text(titulo),
            )
          : ListTile(
              trailing: BalaoNota(nota),
              title: Text(titulo),
            ),
    ));
  }
}
