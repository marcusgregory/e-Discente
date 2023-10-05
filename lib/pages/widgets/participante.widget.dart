import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/models/discente.model.dart';
import 'package:e_discente/models/docente.model.dart';
import 'package:e_discente/models/participante.model.dart';
import 'package:e_discente/pages/widgets/photo_view.widget.dart';

import '../../settings.dart';

class ParticipanteWidget extends StatelessWidget {
  final ParticipanteModel participante;

  const ParticipanteWidget(this.participante, {super.key});

  @override
  Widget build(BuildContext context) {
    if (participante is DocenteModel) {
      DocenteModel docente = participante as DocenteModel;
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          leading: imagemPerfil(
              kIsWeb
                  ? '${Settings.apiURL}/get-image?url=${Uri.encodeComponent(docente.urlFoto!)}'
                  : docente.urlFoto!,
              25),
          title: Text(
            docente.nome!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            docente.departamento!,
            style: const TextStyle(fontSize: 13.5),
          ),
        ),
      );
    } else {
      DiscenteModel discente = participante as DiscenteModel;
      return ListTile(
        leading: imagemPerfil(
            kIsWeb
                ? '${Settings.apiURL}/get-image?url=${Uri.encodeComponent(discente.urlFoto!)}'
                : discente.urlFoto!,
            20),
        title: Text(
          discente.nome!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.8,
          ),
        ),
        subtitle: Text(
          discente.email!,
          style: const TextStyle(fontSize: 13.5),
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
            child: Hero(
              tag: url,
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, imageProvider) => Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: Colors.transparent,
                  child: Ink.image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotoViewWidget(url)));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
