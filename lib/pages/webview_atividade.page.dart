import 'package:e_discente/repositories/sessao_download.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../models/portal.model.dart';

class WebViewAtividade extends StatefulWidget {
  final Atividade atividade;
  const WebViewAtividade({Key? key, required this.atividade}) : super(key: key);

  @override
  State<WebViewAtividade> createState() => _WebViewAtividadeState();
}

class _WebViewAtividadeState extends State<WebViewAtividade> {
  final GlobalKey webViewKey = GlobalKey();
  CookieManager cookieManager = CookieManager.instance();

  InAppWebViewController? webViewController;

  double valueProgress = 0;
  String title = 'SIGAA';

  @override
  void initState() {
    cookieManager.deleteAllCookies();
    SessaoDownload()
        .requestSessaoDownload(widget.atividade.idTurma)
        .then((value) {
      print('ok');
      cookieManager.setCookie(
          url: Uri.parse('https://sig.unilab.edu.br/'),
          name: 'JSESSIONID',
          value: value.cookieSessao ?? '',
          isSecure: true);
      webViewController?.loadUrl(
          urlRequest: URLRequest(
              url: Uri.parse(
                  'https://sig.unilab.edu.br/sigaa/portais/discente/discente.jsf')));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.replay))
          ],
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
        ),
        body: Column(
          children: [
            Visibility(
              visible: !(valueProgress == 1.0),
              child: LinearProgressIndicator(
                  value: valueProgress,
                  color: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  minHeight: 4),
            ),
            Expanded(
                child: InAppWebView(
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://sig.unilab.edu.br/sigaa/portais/discente/discente.jsf')),
            )),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    final controller = webViewController;
    if (controller != null) {
      if (await controller.canGoBack()) {
        controller.goBack();
        return false;
      }
    }
    return true;
  }
}
