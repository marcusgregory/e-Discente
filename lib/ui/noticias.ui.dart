import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/noticias.bloc.dart';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/ui/widgets/noticia.widget.dart';
import 'package:uni_discente/util/toast.util.dart';

class NoticiasPage extends StatefulWidget {
  NoticiasPage({Key key}) : super(key: key);
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage>
    with AutomaticKeepAliveClientMixin {
  NoticiasBloc _noticiasBloc;

  @override
  void initState() {
    _noticiasBloc = new NoticiasBloc();
    super.initState();
  }

  @override
  void dispose() {
    _noticiasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<List<NoticiaModel>>(
      stream: _noticiasBloc.noticiaStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<NoticiaModel>> snapshot) {
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
              return RefreshIndicator(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Noticia(snapshot.data[index]);
                  },
                ),
                onRefresh: () {
                  return _noticiasBloc.load(isRefreshIndicator: true);
                },
              );
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
}
