// @dart=2.9
import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/noticias.bloc.dart';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/pages/widgets/noticia.widget.dart';
import 'package:uni_discente/util/toast.util.dart';

class NoticiasPage extends StatefulWidget {
  NoticiasPage({Key key}) : super(key: key);
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage>
    with AutomaticKeepAliveClientMixin {
  NoticiasBloc _noticiasBloc;
  Stream<List<NoticiaModel>> _noticiaStream;

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
      child: Scrollbar(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: noticias.length,
          itemBuilder: (BuildContext context, int index) {
            return OrientationBuilder(
              builder: (context, orientation) {
                if (MediaQuery.of(context).orientation ==
                    Orientation.portrait) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Noticia(noticias[index]),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 110, right: 110),
                    child: Noticia(noticias[index]),
                  );
                }
              },
            );
          },
        ),
      ),
      onRefresh: () {
        return _noticiasBloc.load(isRefreshIndicator: true);
      },
    );
  }
}
