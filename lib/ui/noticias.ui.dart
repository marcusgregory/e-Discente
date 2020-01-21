import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/noticias.bloc.dart';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/ui/widgets/noticia.widget.dart';
import 'package:uni_discente/util/toast.util.dart';

import '../settings.dart';

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
    _noticiasBloc = new NoticiasBloc();
    _noticiaStream = _noticiasBloc.noticiaStream;
    _noticiasBloc.load();
    super.initState();
  }

  @override
  void dispose() {
    _noticiasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: StreamBuilder<List<NoticiaModel>>(
      stream: _noticiaStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<NoticiaModel>> snapshot) {
        if (Settings.noticias != null) {
          return getListView(Settings.noticias);
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            print('active');
            if (snapshot.hasData) {
              print('hasDada');
              Settings.noticias = snapshot.data;
              return getListView(snapshot.data);
            } else if (snapshot.hasError) {
              print('hasError');
              ToastUtil.showToast('${snapshot.error}');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
            } else {
              print('else');
            }
            break;
          case ConnectionState.done:
            print('done');
            break;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;

  Widget getListView(List<NoticiaModel> noticias) {
    return RefreshIndicator(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: noticias.length,
        itemBuilder: (BuildContext context, int index) {
          return Noticia(noticias[index]);
        },
      ),
      onRefresh: () {
        Settings.noticias=null;
        return _noticiasBloc.load(isRefreshIndicator: true);
      },
    );
  }
}
