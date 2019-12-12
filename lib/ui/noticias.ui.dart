import 'package:flutter/material.dart';
import 'package:unidiscente/blocs/noticias.bloc.dart';
import 'package:unidiscente/models/noticias.model.dart';
import 'package:unidiscente/ui/widgets/noticia.widget.dart';
import 'package:unidiscente/util/toast.util.dart';

class NoticiasPage extends StatefulWidget {
  @override
  _NoticiasPageState createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  @override
  Widget build(BuildContext context) {
    NoticiasBloc noticiasBloc = new NoticiasBloc();
    return MaterialApp(
          home: Material(
        child: Container(
          child: FutureBuilder<List<NoticiaModel>>(
            future: noticiasBloc.getAll(),
            builder: (BuildContext context,
                AsyncSnapshot<List<NoticiaModel>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    ToastUtil.showToast('${snapshot.error}');
                    return Container();
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Noticia(snapshot.data[index]);
                      },
                    );
                  }

                  break;
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
