// @dart=2.9
import 'package:flutter/material.dart';
import 'package:uni_discente/models/notas_turma.model.dart';
import 'package:uni_discente/pages/widgets/balao_resultado.widget.dart';
import 'package:uni_discente/pages/widgets/item_nota.widget.dart';
import 'package:uni_discente/repositories/notas_turma.repository.dart';

class NotasTurmaPage extends StatefulWidget {
  final String idTurma;
  const NotasTurmaPage(this.idTurma);

  @override
  _NotasTurmaPageState createState() => _NotasTurmaPageState();
}

class _NotasTurmaPageState extends State<NotasTurmaPage>
    with AutomaticKeepAliveClientMixin {
  Future<NotasTurmaModel> notasFuture;

  @override
  void initState() {
    notasFuture = NotasTurmaRepository().getNotaTurma(widget.idTurma);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: FutureBuilder(
            future: notasFuture,
            builder: (BuildContext context,
                AsyncSnapshot<NotasTurmaModel> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    NotasTurmaModel notas = snapshot.data;
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                            delegate: SliverChildListDelegate([
                          SizedBox(
                            height: 15,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              bottom: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            elevation: 2.0,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Notas',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Divider(),
                                ),
                                ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: notas.notas.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ItemNota(
                                          notas.notas[index].descricao,
                                          notas.notas[index].valor,
                                          left: false,
                                        ),
                                      );
                                    }),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Card(
                            clipBehavior: Clip.antiAlias,
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                              bottom: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            elevation: 2.0,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Resultados',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Divider(),
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  addAutomaticKeepAlives: true,
                                  physics: ClampingScrollPhysics(),
                                  children: <Widget>[
                                    ItemNota(
                                      'Recuperação',
                                      notas.recuperacao.isNotEmpty
                                          ? notas.recuperacao
                                          : '--',
                                      left: false,
                                    ),
                                    ItemNota(
                                      "Resultado Final",
                                      notas.resultado.isNotEmpty
                                          ? notas.resultado
                                          : '--',
                                      left: false,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Divider(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: ListTile(
                                        subtitle: BalaoSituacao(notas.situacao),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child:
                                              Center(child: Text('Situação')),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]))
                      ],
                    );
                  } else {
                    return Center(
                      child: Text('Ainda sem notas disponíveis.'),
                    );
                  }
                  break;
              }
              return Container();
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
