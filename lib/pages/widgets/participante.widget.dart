import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uni_discente/models/discente.model.dart';
import 'package:uni_discente/models/docente.model.dart';
import 'package:uni_discente/models/participante.model.dart';

class ParticipanteWidget extends StatelessWidget {
  final ParticipanteModel participante;

  const ParticipanteWidget(this.participante);

  @override
  Widget build(BuildContext context) {
    if (participante is DocenteModel) {
      DocenteModel docente = participante;
      return ListTile(
        leading: imagemPerfil(docente.urlFoto),
        title: Text(
          docente.nome,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          docente.departamento,
          style: TextStyle(fontSize: 13.5),
        ),
      );
    } else {
      DiscenteModel discente = participante;
      return ListTile(
        leading: imagemPerfil(discente.urlFoto),
        title: Text(
          discente.nome,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          discente.curso,
          style: TextStyle(fontSize: 13.5),
        ),
      );
    }
  }

  Widget imagemPerfil(String url) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.transparent,
      child: CachedNetworkImage(
        imageUrl:
            url,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Icon(
          Icons.account_circle,
          color: Colors.grey[200],
        ),
        errorWidget: (context, url, error) =>
            Icon(Icons.account_circle, color: Colors.grey[200]),
      ),
    );
  }
}
