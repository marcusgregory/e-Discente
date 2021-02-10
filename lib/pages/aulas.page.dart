import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/aulas.model.dart';
import 'package:uni_discente/models/documento.model.dart';
import 'package:uni_discente/stores/aulas.store.dart';

import 'conteudo.page.dart';

class AulasPage extends StatefulWidget {
  final Aulas _aulasStore;
  final String _idTurma;
  AulasPage(this._aulasStore, this._idTurma);
  @override
  _AulasPageState createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      bottom: false,
      top: false,
      child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Observer(builder: (_) {
            final future = widget._aulasStore.aulas;
            switch (future.status) {
              case FutureStatus.pending:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case FutureStatus.rejected:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        widget._aulasStore.loadAulas(widget._idTurma);
                      },
                      icon: Icon(Icons.refresh),
                    ),
                    Text('Tentar novamente')
                  ],
                );
                break;
              case FutureStatus.fulfilled:
                List<AulaModel> aulas = future.result;
                return CustomScrollView(
                  key: PageStorageKey('aulas:' + widget._idTurma),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        AulaModel aula = aulas[index];
                        return myListTile((index + 1).toString(), aula.titulo,
                            aula.conteudo, aula.documentos);
                      }, childCount: aulas.length),
                    )
                  ],
                );
                break;
            }
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        widget._aulasStore.loadAulas(widget._idTurma);
                      },
                      icon: Icon(Icons.refresh),
                    ),
                    Text('Tentar novamente')
                  ],
                ),
              ),
            );
          })),
    );
  }

  @override
  bool get wantKeepAlive => false;

  Widget myListTile(String numero, String titulo, String conteudo,
      List<DocumentoModel> documentos) {
    return Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(
            left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        elevation: 2.0,
        child: conteudo.trim().isNotEmpty || documentos.isNotEmpty
            ? ListTile(
                key: PageStorageKey(numero),
                leading: balao(numero),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).textTheme.bodyText1.color,
                  size: 15,
                ),
                title: Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConteudoPage(numero, titulo,
                              conteudo, documentos, widget._idTurma)));
                },
              )
            : ListTile(
                leading: balao(numero),
                subtitle: Text('Não há conteúdo'),
                title: Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ));
  }

  Widget balao(String numero) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 30.0,
          height: 30.0,
          decoration: BoxDecoration(
            color: Colors.blueGrey[500],
            shape: BoxShape.circle,
          ),
        ),
        Text(numero + "°",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }
}
