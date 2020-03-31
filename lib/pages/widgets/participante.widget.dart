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
        leading: imagemPerfil(docente.urlFoto, 25),
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
        leading: imagemPerfil(discente.urlFoto, 20),
        title: Text(
          discente.nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.8,
          ),
        ),
        subtitle: Text(
          discente.email,
          style: TextStyle(fontSize: 13.5),
        ),
      );
    }
  }

  Widget imagemPerfil(String url, double radius) {
    if (url.contains('no_picture')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: Image.asset('assets/profile_pic.png').image,
                fit: BoxFit.cover),
          ),
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[200],
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: Image.asset('assets/profile_pic.png').image,
                    fit: BoxFit.cover),
              ),
            ),
          ),
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.transparent,
            child: CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
