import 'package:flutter/material.dart';

import 'package:e_discente/blocs/noticias.bloc.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'package:e_discente/pages/widgets/noticia.widget.dart';
import 'package:e_discente/util/toast.util.dart';

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
  late Stream<NoticiaState> _noticiaStream;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    _noticiaStream = widget.noticiasBloc.noticiaStream;
    super.initState();
  }

  @override
  void dispose() {
    //_noticiaStream = null;
    // widget.noticiasBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<NoticiaState>(
      stream: widget.noticiasBloc.noticiaStream,
      builder: (BuildContext context, snapshot) {
        switch (widget.noticiasBloc.noticiaState) {
          case NoticiaState.loading:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          case NoticiaState.ready:
            return getListView(widget.noticiasBloc.noticiasList);
          case NoticiaState.error:
            ToastUtil.showShortToast('${snapshot.error}');
            return Column(
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
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getListView(List<NoticiaModel>? noticias) {
    return RefreshIndicator(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 1150) {
          return gridView(noticias!);
        } else if (constraints.maxWidth >= 470) {
          return gridView(noticias!);
        } else {
          return listView(noticias!);
        }
      }),
      onRefresh: () {
        return widget.noticiasBloc.load(isRefreshIndicator: true);
      },
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
