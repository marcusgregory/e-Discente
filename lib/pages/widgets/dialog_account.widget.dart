import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_discente/blocs/login.bloc.dart';
import 'package:e_discente/pages/boletim.page.dart';
import 'package:e_discente/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../settings.dart';
import '../../stores/boletim.store.dart';

class DialogAccount extends StatelessWidget {
  const DialogAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return dialogWidget(context);
  }

  Widget dialogWidget(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 22,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('e-Discente',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                    const SizedBox(
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
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          imageUrl: kIsWeb
                              ? '${Settings.apiURL}/get-image?url=${Uri.encodeComponent(Settings.usuario?.urlImagemPerfil ?? '')}'
                              : Settings.usuario?.urlImagemPerfil ?? '',
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
                      Settings.usuario!.nome ?? 'usuario',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(Settings.usuario!.curso ?? 'curso',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                Flexible(
                  child: ListTile(
                    leading: const Icon(Icons.brightness_6_rounded),
                    subtitle: getThemeNameConfig(context),
                    title: const Text(
                      'Tema',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      showThemeChangeDialog(context);
                    },
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListTile(
                    leading: Theme.of(context).platform == TargetPlatform.iOS
                        ? const Icon(CupertinoIcons.graph_square_fill)
                        : const Icon(Icons.timeline),
                    title: const Text(
                      'Meu Boletim',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BoletimPage(
                            boletimStore: Boletim(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Flexible(
                  child: ListTile(
                    leading: const Icon(Icons.web_sharp),
                    trailing: const Icon(Icons.open_in_new),
                    title: const Text(
                      'Abrir Portal da Unilab',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                    leading: const Icon(Icons.open_in_browser),
                    trailing: const Icon(Icons.open_in_new),
                    title: const Text(
                      'Abrir SIGAA',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onTap: () async {
                      String url = '';
                      if (kIsWeb) {
                        url = 'https://sig.unilab.edu.br/sigaa/public/home.jsf';
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
                    leading: const Icon(Icons.logout_rounded),
                    title: const Text(
                      'Sair',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onTap: () async {
                      await LoginBloc().deslogar();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const LoginPageN()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ),
                Flexible(
                  child: ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text(
                      'Ajuda e Feedback',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                    leading: const Icon(Icons.info_rounded),
                    title: const Text(
                      'Sobre',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                                borderRadius: BorderRadius.circular(100.0),
                                child: Image.asset('assets/book.png'))),
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: const Text(
                        'Política de Privacidade',
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () => {},
                    ),
                    const Text('•'),
                    InkWell(
                      child: const Text(
                        'Termos de Serviço',
                        style: TextStyle(fontSize: 12),
                      ),
                      onTap: () => {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        ));
    //
  }
}

Text getThemeNameConfig(BuildContext context) {
  switch (AdaptiveTheme.of(context).mode.name) {
    case 'Light':
      return const Text('Claro');
    case 'Dark':
      return const Text('Escuro');
    case 'System':
      return const Text('Automático (sistema)');
    default:
      return const Text('Nenhum');
  }
}

void setThemeConfigByName(BuildContext context, String name) {
  switch (name) {
    case 'Light':
      AdaptiveTheme.of(context).setLight();
      break;
    case 'Dark':
      AdaptiveTheme.of(context).setDark();
      break;
    case 'System':
      AdaptiveTheme.of(context).setSystem();
      break;
    default:
      AdaptiveTheme.of(context).setSystem();
  }
}

void showThemeChangeDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        String? selectedRadio = AdaptiveTheme.of(context).mode.name;
        return AlertDialog(
          title: const Text('Escolha um tema'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Automático (sistema)'),
                  leading: Radio<String>(
                    value: 'System',
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() => selectedRadio = value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Claro'),
                  leading: Radio<String>(
                    value: 'Light',
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() => selectedRadio = value);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Escuro'),
                  leading: Radio<String>(
                    value: 'Dark',
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setState(() => selectedRadio = value);
                    },
                  ),
                ),
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text("CANCELAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                setThemeConfigByName(context, selectedRadio ?? '');
                Navigator.of(context).pop();
              },
            ),
          ],
          contentPadding: EdgeInsets.zero,
        );
      });
}
