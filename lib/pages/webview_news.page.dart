import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewNews extends StatefulWidget {
  final String newsUrl;
  const WebViewNews({Key? key, required this.newsUrl}) : super(key: key);

  @override
  State<WebViewNews> createState() => _WebViewNewsState();
}

class _WebViewNewsState extends State<WebViewNews> {
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  double valueProgress = 0;
  String title = 'Carregando...';

  @override
  void initState() {
    controller.loadRequest(Uri.parse(widget.newsUrl));
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          setState(() {
            valueProgress = progress.toDouble() / 100;
          });
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          controller.getTitle().then((value) {
            setState(() {
              title = value ?? '';
            });
          });
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
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
            IconButton(
                onPressed: () {
                  controller.reload();
                },
                icon: const Icon(Icons.replay))
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
            Expanded(child: WebViewWidget(controller: controller)),
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controller.canGoBack()) {
      print("onwill goback");
      controller.goBack();
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }
}
