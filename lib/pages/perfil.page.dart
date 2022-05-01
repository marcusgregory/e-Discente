import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:e_discente/models/perfil.model.dart';
import 'package:e_discente/pages/widgets/photo_view.widget.dart';
import 'package:e_discente/stores/perfil.store.dart';
import 'package:e_discente/util/toast.util.dart';
import '../settings.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key, required this.perfilStore}) : super(key: key);
  final PerfilStore perfilStore;
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
    with AutomaticKeepAliveClientMixin {
  late PerfilStore store;
  @override
  void initState() {
    store = widget.perfilStore;
    if (store.firstRun) store.loadPerfil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: ListView(
        key: const PageStorageKey('Perfil-header'),
        primary: false,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          getHeaderProfile(),
          Observer(builder: (BuildContext context) {
            final future = store.perfilDiscente!;
            switch (future.status) {
              case FutureStatus.pending:
                return Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator.adaptive(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Carregando mais informações...'),
                  ],
                );
              case FutureStatus.rejected:
                return Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        store.loadPerfil();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    const Text('Tentar novamente')
                  ],
                );
              case FutureStatus.fulfilled:
                return widgetPerfil(future.result);
            }
          }),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getProfilePic(String url) {
    return Stack(
      children: <Widget>[
        Center(
          child: CircleAvatar(
            radius: 58,
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
        ),
        Center(
          child: CircleAvatar(
            radius: 58,
            backgroundColor: Colors.transparent,
            child: Hero(
              tag: url,
              child: CachedNetworkImage(
                imageUrl: kIsWeb
                    ? 'https://api.allorigins.win/raw?url=' +
                        Uri.encodeComponent(url)
                    : url,
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
        ),
      ],
    );
  }

  Widget getHeaderProfile() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Observer(builder: (BuildContext context) {
            final future = store.perfilDiscente!;
            switch (future.status) {
              case FutureStatus.pending:
                return CircularPercentIndicator(
                  radius: 66,
                  lineWidth: 5.0,
                  center: getProfilePic(Settings.usuario!.urlImagemPerfil!),
                  percent: 0.0,
                  animation: true,
                  animationDuration: 500,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                );
              case FutureStatus.fulfilled:
                return CircularPercentIndicator(
                  radius: 66,
                  lineWidth: 5.0,
                  center: getProfilePic(Settings.usuario!.urlImagemPerfil!),
                  percent: int.parse(future.result.integralizacao) / 100,
                  animation: true,
                  animationDuration: 800,
                  progressColor: Theme.of(context).colorScheme.secondary,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                );
              case FutureStatus.rejected:
                return getProfilePic(Settings.usuario!.urlImagemPerfil!);
            }
          }),
        ),
        //getProfilePic(Settings.usuario.urlImagemPerfil),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            Settings.usuario!.nome!,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            Settings.usuario!.curso!,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 18,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Divider(),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget widgetPerfil(PerfilModel perfilModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: <Widget>[
            ListTile(
              title: const Text(
                'Curso',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.folder_fill_badge_person_crop)
                  : const Icon(Icons.school),
              subtitle: Text(perfilModel.curso!),
              onTap: () {
                Clipboard.setData(ClipboardData(text: Settings.usuario!.curso));
                ToastUtil.showShortToast(
                    'Curso copiado para área de transferência.');
              },
            ),
            ListTile(
              title: const Text(
                'Matrícula',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.checkmark_shield_fill)
                  : const Icon(Icons.offline_pin),
              subtitle: Text(Settings.usuario!.numMatricula!),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: Settings.usuario!.numMatricula));
                ToastUtil.showShortToast(
                    'Matrícula copiada para área de transferência.');
              },
            ),
            ListTile(
              title: const Text(
                'Integralização',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.chart_bar_square_fill)
                  : const Icon(Icons.insert_chart),
              subtitle: Text(perfilModel.integralizacao! + '%'),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: perfilModel.integralizacao));
                ToastUtil.showShortToast(
                    'Integralização copiado para área de transferência.');
              },
            ),
            ListTile(
              title: const Text(
                'Nível',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.asterisk_circle_fill)
                  : const Icon(Icons.assistant),
              subtitle: Text(perfilModel.nivel!),
              onTap: () {
                Clipboard.setData(ClipboardData(text: perfilModel.nivel));
                ToastUtil.showShortToast(
                    'Nível copiado para área de transferência.');
              },
            ),
            ListTile(
              title: const Text(
                'Situação',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.doc_text_fill)
                  : const Icon(Icons.assignment),
              subtitle: Text(perfilModel.situacao!),
              onTap: () {
                Clipboard.setData(ClipboardData(text: perfilModel.situacao));
                ToastUtil.showShortToast(
                    'Situação copiada para área de transferência.');
              },
            ),
            ListTile(
              title: const Text(
                'Semestre de Entrada',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.calendar)
                  : const Icon(Icons.event_available),
              subtitle: Text(perfilModel.semestreEntrada!),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: perfilModel.semestreEntrada));
                ToastUtil.showShortToast(
                    'Semestre copiado para área de transferência.');
              },
            ),
            ListTile(
              title: const Text(
                'IDE',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.graph_square_fill)
                  : const Icon(Icons.timeline),
              subtitle: Text(perfilModel.iDE!),
              onTap: () {
                Clipboard.setData(ClipboardData(text: perfilModel.iDE));
                ToastUtil.showShortToast(
                    'IDE copiado para área de transferência.');
              },
            )
          ],
        ),
      ],
    );
  }
}
