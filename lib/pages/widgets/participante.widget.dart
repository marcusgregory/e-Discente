import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/models/discente.model.dart';
import 'package:e_discente/models/docente.model.dart';
import 'package:e_discente/models/participante.model.dart';
import 'package:e_discente/pages/widgets/photo_view.widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../settings.dart';
import '../../util/toast.util.dart';

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
          trailing: IconButton(
              onPressed: () {
                openUrl('mailto:${docente.email!}');
              },
              icon: const Icon(Icons.email_rounded)),
          leading: imagemPerfil(
              kIsWeb
                  ? '${Settings.apiURL}/get-image?url=${Uri.encodeComponent(docente.urlFoto!)}'
                  : docente.urlFoto!,
              25),
          title: Text(
            docente.nome!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                docente.departamento!,
                style: const TextStyle(fontSize: 13.5),
              ),
              Text(
                docente.email!,
                style: const TextStyle(fontSize: 13.5),
              ),
            ],
          ),
        ),
      );
    } else {
      DiscenteModel discente = participante as DiscenteModel;
      return ListTile(
        trailing: IconButton(
            onPressed: () {
              openUrl('mailto:${discente.email!}');
            },
            icon: const Icon(Icons.email_outlined)),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "@${discente.usuario!}",
              style: const TextStyle(fontSize: 13.5),
            ),
            Text(
              discente.email!,
              style: const TextStyle(fontSize: 13.5),
            ),
          ],
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

  Future<void> openUrl(String urlFile) async {
    String url = Uri.encodeFull(urlFile);
    if (await launchUrlString(url, mode: LaunchMode.externalApplication)) {
    } else {
      ToastUtil.showShortToast("Não foi possível abrir a url");
    }
  }
}
