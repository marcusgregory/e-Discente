// @dart=2.9
import 'package:flutter/material.dart';
import 'package:e_discente/blocs/noticias.bloc.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'package:e_discente/pages/widgets/noticia.widget.dart';
import 'package:e_discente/util/toast.util.dart';

class NoticiasPage extends StatefulWidget {
  NoticiasPage({Key key}) : super(key: key);
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage>
    with AutomaticKeepAliveClientMixin {
  NoticiasBloc _noticiasBloc;
  Stream<List<NoticiaModel>> _noticiaStream;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    _noticiasBloc = NoticiasBloc();
    _noticiaStream = _noticiasBloc.noticiaStream;
    _noticiasBloc.load();
    super.initState();
  }

  @override
  void dispose() {
    _noticiaStream = null;
    _noticiasBloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<NoticiaModel>>(
      stream: _noticiaStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<NoticiaModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
              return getListView(snapshot.data);
            } else if (snapshot.hasError) {
              ToastUtil.showShortToast('${snapshot.error}');
              return Column(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _noticiasBloc.load();
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  Text('Tentar novamente')
                ],
              );
            } else {}
            break;
          case ConnectionState.done:
            break;
        }
        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget getListView(List<NoticiaModel> noticias) {
    return RefreshIndicator(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth >= 1150) {
          return gridView(noticias);
        } else if (constraints.maxWidth >= 470) {
          return gridView(noticias);
        } else {
          return listView(noticias);
        }
      }),
      onRefresh: () {
        return _noticiasBloc.load(isRefreshIndicator: true);
      },
    );
  }

  Widget listView(List<NoticiaModel> noticias) {
    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: noticias.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Noticia(noticias[index]),
        );
      },
    );
  }

  Widget gridView(List<NoticiaModel> noticias) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
          child: Noticia(noticias[index]),
        );
      },
    );
  }
}
