import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/aulas.model.dart';
import 'package:uni_discente/stores/aulas.store.dart';
import 'package:uni_discente/util/toast.util.dart';
import 'package:url_launcher/url_launcher.dart';

class AulasPage extends StatefulWidget {
  final String _titulo;
  final String _idTurma;

  const AulasPage(this._titulo, this._idTurma);

  @override
  _AulasPageState createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  Aulas _aulasStore = Aulas();
  @override
  void initState() {
    _aulasStore.loadAulas(widget._idTurma);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._titulo)),
      body: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Observer(builder: (_) {
            final future = _aulasStore.aulas;
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
                        _aulasStore.loadAulas(widget._idTurma);
                      },
                      icon: Icon(Icons.refresh),
                    ),
                    Text('Tentar novamente')
                  ],
                );
                break;
              case FutureStatus.fulfilled:
                List<AulaModel> aulas = future.result;
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: aulas.length,
                    itemBuilder: (BuildContext context, int index) {
                      AulaModel aula = aulas[index];
                      return myExpansionTile(
                          (index + 1).toString(), aula.titulo, aula.conteudo);
                    },
                  ),
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
                        _aulasStore.loadAulas(widget._idTurma);
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

  Widget myExpansionTile(String numero, String titulo, String conteudo) {
    return Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(
            left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        elevation: 2.0,
        child: conteudo.trim().isNotEmpty
            ? ExpansionTile(
                leading: balao(numero),
                title: Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 0, bottom: 0),
                      child: Divider(
                        color: Colors.black38,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Html(
                        data: conteudo,
                        defaultTextStyle: TextStyle(fontSize: 14),
                        onLinkTap: (url) async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            ToastUtil.showShortToast(
                                'Não foi possível abrir a url: $url');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ])
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
