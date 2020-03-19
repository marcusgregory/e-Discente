import 'package:flutter/material.dart';
import 'package:uni_discente/models/participantes.model.dart';
import 'package:uni_discente/pages/widgets/participante.widget.dart';
import 'package:uni_discente/repositories/participantes.repository.dart';

class ParticipantesPage extends StatefulWidget {
  final String _idTurma;
  const ParticipantesPage(this._idTurma);
  @override
  _ParticipantesPageState createState() => _ParticipantesPageState();
}

class _ParticipantesPageState extends State<ParticipantesPage> with AutomaticKeepAliveClientMixin {
  Future<ParticipantesModel> participantesFuture;
  @override
  void initState() {
    participantesFuture =
        ParticipantesRepository().getParticipantes(widget._idTurma);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: FutureBuilder(
            future: participantesFuture,
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
                    ParticipantesModel participantes = snapshot.data;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Docente(s)',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.black38,
                                ),
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(left: 80,right: 15),
                                  child: Divider(
                                    color: Colors.black26,
                                  ),
                                ),
                                itemCount: participantes.docentes.length,
                                itemBuilder: (context, position) {
                                  return ParticipanteWidget(
                                      participantes.docentes[position]);
                                },
                                shrinkWrap:
                                    true, // todo comment this out and check the result
                                physics:
                                    ClampingScrollPhysics(), // todo comment this out and check the result
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Discentes',
                                style: Theme.of(context).textTheme.body2,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.black38,
                                ),
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(left: 80,right: 15),
                                  child: Divider(
                                    color: Colors.black26,
                                  ),
                                ),
                                itemCount: participantes.discentes.length,
                                itemBuilder: (context, position) {
                                  return ParticipanteWidget(
                                      participantes.discentes[position]);
                                },
                                shrinkWrap:
                                    true, // todo comment this out and check the result
                                physics:
                                    ClampingScrollPhysics(), // todo comment this out and check the result
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: 1,
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
