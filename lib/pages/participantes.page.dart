import 'package:flutter/material.dart';
import 'package:uni_discente/models/participantes.model.dart';
import 'package:uni_discente/pages/widgets/participante.widget.dart';

class ParticipantesPage extends StatefulWidget {
  final Future<ParticipantesModel> _participantesFuture;
  final String _idTurma;
  const ParticipantesPage(this._participantesFuture, this._idTurma);
  @override
  _ParticipantesPageState createState() => _ParticipantesPageState();
}

class _ParticipantesPageState extends State<ParticipantesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: FutureBuilder(
            future: widget._participantesFuture,
            builder: (BuildContext context,
                AsyncSnapshot<ParticipantesModel> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    ParticipantesModel participantesModel = snapshot.data;
                    List<dynamic> participantes = [
                      ...participantesModel.docentes,
                      ...participantesModel.discentes
                    ];
                    return CustomScrollView(
                      slivers: <Widget>[
                        SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context)),
                        SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Docentes',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Divider(
                                        color: Colors.grey[350],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else if (index ==
                              participantesModel.docentes.length + 1) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Divider(
                                        color: Colors.grey[350],
                                      ),
                                    ),
                                    Text(
                                      'Discentes',
                                      style: Theme.of(context).textTheme.body2,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Divider(
                                        color: Colors.grey[350],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return ParticipanteWidget(participantes[index - 1]);
                          }
                        }, childCount: participantes.length + 1)),
                      ],
                    );
                  }
                  break;
              }
              return Container();
            }));
  }

  @override
  bool get wantKeepAlive => false;
}
