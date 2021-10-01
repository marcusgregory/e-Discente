import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:e_discente/blocs/usuario.bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../settings.dart';
import '../login.page.dart';

class DialogAccount extends StatelessWidget {
  const DialogAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dialogWidget(context);
  }

  Widget dialogWidget(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 22,
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text('e-Discente',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          )),
                      SizedBox(
                        height: 24,
                        width: 45,
                      )
                    ],
                  ),
                  // Theme(
                  //   data: ThemeData().copyWith(
                  //       appBarTheme: AppBarTheme().copyWith(
                  //           backgroundColor: Theme.of(context).cardColor)),
                  //   child: AppBar(
                  //     elevation: 0,
                  //     leading: IconButton(
                  //       iconSize: 22,
                  //       icon: Icon(Icons.close),
                  //       onPressed: () => Navigator.pop(context),
                  //     ),
                  //     title: Text('e-Discente',
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 17,
                  //         )),
                  //     centerTitle: true,
                  //   ),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(100.0),
                          child: CachedNetworkImage(
                            imageUrl: kIsWeb
                                ? 'https://api.allorigins.win/raw?url=' +
                                    Uri.encodeComponent(
                                        Settings.usuario.urlImagemPerfil)
                                : Settings.usuario.urlImagemPerfil,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Icon(
                              Icons.account_circle,
                              color: Colors.grey[200],
                            ),
                            errorWidget: (context, url, error) => Icon(
                                Icons.account_circle,
                                color: Colors.grey[200]),
                          ),
                        ),
                      ),
                      title: Text(
                        Settings.usuario.nome,
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(Settings.usuario.curso,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Flexible(
                    child: ListTile(
                      leading: Icon(Icons.brightness_6_rounded),
                      title: Text(
                        'Modo noturno',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      trailing: Switch.adaptive(
                          value: AdaptiveTheme.of(context).mode.isDark,
                          onChanged: (_) {
                            if (AdaptiveTheme.of(context).mode.isDark) {
                              AdaptiveTheme.of(context).setLight();
                            } else {
                              AdaptiveTheme.of(context).setDark();
                            }
                          }),
                    ),
                  ),
                  Divider(),
                  Flexible(
                    child: ListTile(
                      leading: Icon(Icons.web_sharp),
                      trailing: Icon(Icons.open_in_new),
                      title: Text(
                        'Abrir Portal da Unilab',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        String url = 'https://unilab.edu.br';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: Icon(Icons.open_in_browser),
                      trailing: Icon(Icons.open_in_new),
                      title: Text(
                        'Abrir SIGAA',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        String url = '';
                        if (kIsWeb) {
                          url =
                              'https://sig.unilab.edu.br/sigaa/public/home.jsf';
                        } else {
                          if (Platform.isIOS || Platform.isAndroid) {
                            url =
                                'https://sig.unilab.edu.br/sigaa/mobile/touch/public/principal.jsf';
                          } else {
                            url =
                                'https://sig.unilab.edu.br/sigaa/public/home.jsf';
                          }
                        }
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: Icon(Icons.logout_rounded),
                      title: Text(
                        'Sair',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        await UsuarioBloc().deslogar();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginPage()));
                      },
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: Icon(Icons.help),
                      title: Text(
                        'Ajuda e Feedback',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        String url =
                            'mailto:dev.marcusgregory@gmail.com?Subject=Ajuda%20e%20Feedback%20do%20e-Discente';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      leading: Icon(Icons.info_rounded),
                      title: Text(
                        'Sobre',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      onTap: () async {
                        showAboutDialog(
                          context: context,
                          applicationName: 'e-Discente',
                          applicationLegalese:
                              'Uma aplicação para facilitar o uso do Sistema Integrado de Gestão de Atividades Acadêmicas.',
                          applicationVersion: '0.0.1-alpha',
                          applicationIcon: CircleAvatar(
                              child: ClipRRect(
                                  borderRadius:
                                      new BorderRadius.circular(100.0),
                                  child: Image.asset('assets/book.png'))),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Text(
                          'Política de Privacidade',
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => {},
                      ),
                      Text('•'),
                      InkWell(
                        child: Text(
                          'Termos de Serviço',
                          style: TextStyle(fontSize: 12),
                        ),
                        onTap: () => {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
        ));
    //
  }
}
