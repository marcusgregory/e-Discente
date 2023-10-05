import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/portal.model.dart';

class TarefaWidget extends StatelessWidget {
  final Atividade atividade;
  const TarefaWidget({
    Key? key,
    required this.atividade,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color color;
    switch (atividade.priority) {
      case TaskPriority.low:
        color = const Color(0xFFD2ECC9);
        break;
      case TaskPriority.medium:
        color = const Color(0xFFECEAB6);
        break;
      case TaskPriority.high:
        color = const Color(0xFFF9D0D0);
        break;
      case TaskPriority.none:
        color = Colors.grey[200] ?? Colors.grey;
        break;
    }

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Theme.of(context).brightness == Brightness.light
            ? color
            : const Color(0xFF262C31),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      circle(atividade.priority),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(atividade.textTaskLeft,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.darkerGrotesque(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Text(atividade.nomeDisciplina,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.darkerGrotesque(
                          fontSize: 14, fontWeight: FontWeight.w900)),
                  Text(atividade.conteudo,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.darkerGrotesque(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  Text(atividade.data,
                      style: GoogleFonts.darkerGrotesque(
                          fontSize: 11.5, fontWeight: FontWeight.w600)),
                  Visibility(
                      visible: atividade.hora.isNotEmpty,
                      child: Text(' - ${atividade.hora}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.darkerGrotesque(
                              fontSize: 11.5, fontWeight: FontWeight.w600))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circle(TaskPriority priority) {
    late Color color;
    switch (priority) {
      case TaskPriority.low:
        color = const Color(0xFF51BA40);
        break;
      case TaskPriority.medium:
        color = const Color(0xFFFFC700);
        break;
      case TaskPriority.high:
        color = const Color(0xFFF62A1D);
        break;
      case TaskPriority.none:
        color = Colors.grey;
        break;
    }
    return Container(
        width: 8.0,
        height: 8.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ));
  }
}

enum TaskPriority { low, medium, high, none }
