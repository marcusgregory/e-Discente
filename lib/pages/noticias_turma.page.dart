import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../blocs/noticias_turma.bloc.dart';
import '../util/toast.util.dart';

class NoticiasTurmaPage extends StatelessWidget {
  final String idTurma;
  final NoticiasTurmaBloc controller;
  const NoticiasTurmaPage(
      {super.key, required this.idTurma, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder(
          stream: controller.stream,
          builder: (context, snapshot) {
            switch (controller.noticiaState) {
              case NoticiaTurmaState.initial:
                return Container();
              case NoticiaTurmaState.loading:
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              case NoticiaTurmaState.ready:
                if (controller.noticiasList.isEmpty) {
                  return const Center(
                    child: Text('Ainda sem noticias.'),
                  );
                }
                return CustomScrollView(
                  key: PageStorageKey('noticias:$idTurma'),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          elevation: 2.0,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      width: 40,
                                      child: Icon(Icons.circle, size: 8),
                                    ),
                                    Flexible(
                                      child: Center(
                                        child: Text(
                                          controller.noticiasList[index].titulo,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                          maxLines: 3,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        iconSize: 20,
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                            text: controller
                                                .noticiasList[index].conteudo,
                                          ));
                                          ToastUtil.showShortToast(
                                              'Texto copiado para área de transferência.');
                                        },
                                        icon: const Icon(Icons.copy))
                                  ],
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Divider()),
                              controller.noticiasList[index].html.isNotEmpty
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(controller
                                              .noticiasList[index].data),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Html(
                                              data: controller
                                                  .noticiasList[index].html,
                                              onLinkTap: (String? url,
                                                  Map<String, String>
                                                      attributes,
                                                  element) {
                                                openUrl(url ?? '');
                                              }),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(50.0),
                                      child: Center(
                                        child: Text('Sem conteúdo'),
                                      ),
                                    )
                            ],
                          ),
                        );
                      }, childCount: controller.noticiasList.length),
                    )
                  ],
                );

              case NoticiaTurmaState.error:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          controller.load();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      const Text('Tentar novamente')
                    ],
                  ),
                );
            }
          }),
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
