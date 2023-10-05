import 'dart:math';
import 'dart:ui';

import 'package:e_discente/pages/widgets/user_appbar.widget.dart';
import 'package:flutter/material.dart';

import 'package:e_discente/blocs/noticias.bloc.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'package:e_discente/pages/widgets/noticia.widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NoticiasPage extends StatefulWidget {
  final NoticiasBloc noticiasBloc;

  const NoticiasPage({
    Key? key,
    required this.noticiasBloc,
  }) : super(key: key);

  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController controller = ScrollController();

  late List<NoticiaModel> noticiasListFake = List.generate(
    10,
    (index) => NoticiaModel(
        id: Random().nextInt(100000),
        conteudo:
            'A Universidade da Integração Internacional da Lusofonia Afro-Brasileira (Unilab) participou, por meio da Pró-reitoria de Pesquisa e Pós-Graduação (Proppg) e da Coordenação de Inovação Tecnológica (CIT), da solenidade de apresentação dos ambientes de inovação do Programa Corredores Digitais da Secretaria da Ciência, Tecnologia e Educação Superior (Secitece), que ocorreu no dia 08 de agosto de 2023, no Auditório desta Secretaria.',
        data: '2023-08-18T16:57:35',
        imagem: '',
        resumo:
            'A Universidade da Integração Internacional da Lusofonia Afro-Brasileira (Unilab) participou, por meio da Pró-reitoria de Pesquisa e Pós-Graduação (Proppg) e da Coordenação de Inovação Tecnológica (CIT), da solenidade de apresentação dos ambientes de inovação do Programa Corredores Digitais da Secretaria da Ciência, Tecnologia e Educação Superior (Secitece), que ocorreu no dia 08 de agosto de 2023, no Auditório desta Secretaria.',
        titulo:
            'Unilab participa da solenidade de apresentação da Rede de Ambientes de Inovação do Ceará',
        url:
            'https://unilab.edu.br/2023/08/17/unilab-participa-da-solenidade-de-apresentacao-da-rede-de-ambientes-de-inovacao-do-ceara/'),
  );

  @override
  void dispose() {
    //_noticiaStream = null;
    // widget.noticiasBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: userAppBar(title: 'Notícias', context: context),
      body: SafeArea(
        child: StreamBuilder<NoticiaState>(
          stream: widget.noticiasBloc.noticiaStream,
          builder: (BuildContext context, snapshot) {
            switch (widget.noticiasBloc.noticiaState) {
              case NoticiaState.loading:
                return getListView(noticiasListFake, loading: true);
              case NoticiaState.ready:
                return getListView(widget.noticiasBloc.noticiasList);
              case NoticiaState.error:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          widget.noticiasBloc.load();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      const Text('Tentar novamente')
                    ],
                  ),
                );
              default:
                Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        widget.noticiasBloc.load();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    const Text('Tentar novamente')
                  ],
                );
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getListView(List<NoticiaModel>? noticias, {loading = false}) {
    return Skeletonizer(
      enabled: loading,
      child: RefreshIndicator.adaptive(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad
            },
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth >= 1150) {
              return gridView(noticias!);
            } else if (constraints.maxWidth >= 470) {
              return gridView(noticias!);
            } else {
              return listView(noticias!);
            }
          }),
        ),
        onRefresh: () {
          return widget.noticiasBloc.load(isRefreshIndicator: false);
        },
      ),
    );
  }

  Widget listView(List<NoticiaModel> noticias) {
    return ListView.builder(
      key: const PageStorageKey('noticias'),
      addAutomaticKeepAlives: true,
      controller: controller,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: noticias.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Noticia(
            noticia: noticias[index],
            key: ValueKey(noticias[index].id),
          ),
        );
      },
    );
  }

  Widget gridView(List<NoticiaModel> noticias) {
    return GridView.builder(
      key: const PageStorageKey('noticias-grid'),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 400,
          maxCrossAxisExtent: 400,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: noticias.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Noticia(
            noticia: noticias[index],
            key: ValueKey(noticias[index].id),
          ),
        );
      },
    );
  }
}
