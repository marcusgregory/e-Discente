import 'dart:async';

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
   StreamController<List<NoticiaModel>> streamController;

  @override
  void initState() {
    streamController= StreamController();
    load();
    super.initState();
  }

  load() async {
    try{
    List<NoticiaModel> list = await NoticiasBloc().getAll();

    streamController.sink.add(list);
    }catch(e){
      streamController.addError(e);
    }
  }


  @override
    void dispose() {
      streamController.close();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<NoticiaModel>>(
      stream: streamController.stream,
      builder: (BuildContext context, AsyncSnapshot<List<NoticiaModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            if (snapshot.hasData) {
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
                  return load();
                },
              );
            } else if (snapshot.hasError) {
              ToastUtil.showToast('${snapshot.error}');
              return Center(
                child: FlatButton(
                  child: Text("Tentar novamente"),
                  onPressed: () {
                    load();
                  },
                ),
              );
            } else {
              return new Text("Nothing");
            }
            break;
          case ConnectionState.done:
            break;
        }
        return Container();
      },
    )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
