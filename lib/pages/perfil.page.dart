import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uni_discente/models/perfil.model.dart';
import 'package:uni_discente/stores/perfil.store.dart';
import 'package:uni_discente/util/toast.util.dart';
import '../settings.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
    with AutomaticKeepAliveClientMixin {
  final PerfilStore store = PerfilStore();
  @override
  void initState() {
    store.loadPerfil();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          getHeaderProfile(),
          Observer(builder: (BuildContext context) {
            final future = store.perfilDiscente;
            switch (future.status) {
              case FutureStatus.pending:
                return Container(
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Carregando mais informações...'),
                    ],
                  ),
                );
              case FutureStatus.rejected:
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        store.loadPerfil();
                      },
                      icon: Icon(Icons.refresh),
                    ),
                    Text('Tentar novamente')
                  ],
                );
              case FutureStatus.fulfilled:
                return widgetPerfil(future.result);
            }
            return Container();
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
        ),
      ],
    );
  }

  Widget getHeaderProfile() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Center(
          child: Observer(builder: (BuildContext context) {
            final future = store.perfilDiscente;
            switch (future.status) {
              case FutureStatus.pending:
                return CircularPercentIndicator(
                  radius: 130,
                  lineWidth: 5.0,
                  center: getProfilePic(Settings.usuario.urlImagemPerfil),
                  percent: 0.0,
                  animation: true,
                  animationDuration: 500,
                  progressColor: Theme.of(context).accentColor,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                );
                break;
              case FutureStatus.fulfilled:
                return CircularPercentIndicator(
                  radius: 130,
                  lineWidth: 5.0,
                  center: getProfilePic(Settings.usuario.urlImagemPerfil),
                  percent: int.parse(future.result.integralizacao) / 100,
                  animation: true,
                  animationDuration: 800,
                  progressColor: Theme.of(context).accentColor,
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.transparent,
                );
                break;
              case FutureStatus.rejected:
                return getProfilePic(Settings.usuario.urlImagemPerfil);
                break;
            }
            return getProfilePic(Settings.usuario.urlImagemPerfil);
          }),
        ),
        //getProfilePic(Settings.usuario.urlImagemPerfil),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            Settings.usuario.nome,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            Settings.usuario.curso,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 18,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            color: Colors.grey[300],
            height: 1,
          ),
        ),
        SizedBox(
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
              title: Text(
                'Curso',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.school),
              subtitle: Text(perfilModel.curso),
              onTap: () {
                Clipboard.setData(ClipboardData(text: Settings.usuario.curso));
                ToastUtil.showShortToast(
                    'Curso copiado para área de transferência.');
              },
            ),
            ListTile(
              title: Text(
                'Matrícula',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.offline_pin),
              subtitle: Text(Settings.usuario.numMatricula),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: Settings.usuario.numMatricula));
                ToastUtil.showShortToast(
                    'Matrícula copiada para área de transferência.');
              },
            ),
            ListTile(
              title: Text(
                'Integralização',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.insert_chart),
              subtitle: Text(perfilModel.integralizacao + '%'),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: perfilModel.integralizacao));
                ToastUtil.showShortToast(
                    'Integralização copiado para área de transferência.');
              },
            ),
            ListTile(
              title: Text(
                'Nível',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.assistant),
              subtitle: Text(perfilModel.nivel),
              onTap: () {
                Clipboard.setData(ClipboardData(text: perfilModel.nivel));
                ToastUtil.showShortToast(
                    'Nível copiado para área de transferência.');
              },
            ),
            ListTile(
              title: Text(
                'Situação',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.assignment),
              subtitle: Text(perfilModel.situacao),
              onTap: () {
                Clipboard.setData(ClipboardData(text: perfilModel.situacao));
                ToastUtil.showShortToast(
                    'Situação copiada para área de transferência.');
              },
            ),
            ListTile(
              title: Text(
                'Semestre de Entrada',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.event_available),
              subtitle: Text(perfilModel.semestreEntrada),
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: perfilModel.semestreEntrada));
                ToastUtil.showShortToast(
                    'Semestre copiado para área de transferência.');
              },
            ),
            ListTile(
              title: Text(
                'IDE',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              leading: Icon(Icons.timeline),
              subtitle: Text(perfilModel.iDE),
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
