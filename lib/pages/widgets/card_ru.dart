import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/saldo.utils.dart';

class CardRu extends StatelessWidget {
  final String saldo;
  final Function reload;
  const CardRu({
    Key? key,
    required this.saldo,
    required this.reload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.credit_card_rounded),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('R\$ $saldo',
                          style: GoogleFonts.darkerGrotesque(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                      SaldoUtils.textoRefeicoes(
                          SaldoUtils.refeicoesRestantes(saldo)),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.darkerGrotesque(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                reload();
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }
}
