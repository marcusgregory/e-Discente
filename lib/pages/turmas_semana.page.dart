import 'package:e_discente/blocs/turmas_calendario.bloc.dart';
import 'package:e_discente/models/turma_calendario.model.dart';
import 'package:e_discente/pages/widgets/turmas_calendario.widget.dart';
import 'package:flutter/material.dart';

class TurmasSemanaPage extends StatelessWidget {
  final TurmasCalendarioBloc turmasCalendario;
  const TurmasSemanaPage({super.key, required this.turmasCalendario});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'SEG',
              ),
              Tab(
                text: 'TER',
              ),
              Tab(
                text: 'QUA',
              ),
              Tab(
                text: 'QUI',
              ),
              Tab(
                text: 'SEX',
              ),
            ],
          ),
          title: const Text('Aulas da Semana'),
        ),
        body: TabBarView(
          children: [
            TurmasDiaSemana(
                dia: 'Segunda', turmasCalendarioBloc: turmasCalendario),
            TurmasDiaSemana(
                dia: 'Terça', turmasCalendarioBloc: turmasCalendario),
            TurmasDiaSemana(
                dia: 'Quarta', turmasCalendarioBloc: turmasCalendario),
            TurmasDiaSemana(
                dia: 'Quinta', turmasCalendarioBloc: turmasCalendario),
            TurmasDiaSemana(
                dia: 'Sexta', turmasCalendarioBloc: turmasCalendario),
          ],
        ),
      ),
    );
  }
}

class TurmasDiaSemana extends StatelessWidget {
  final String dia;
  final TurmasCalendarioBloc turmasCalendarioBloc;
  const TurmasDiaSemana(
      {super.key, required this.dia, required this.turmasCalendarioBloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: turmasCalendarioBloc.turmaStream,
        builder: (context, snapshot) {
          var list = turmasCalendarioBloc.completeList.where((element) {
            bool isOk = false;
            for (var turma in element.horariosDefinidos) {
              isOk = turma.dias.contains(dia.trim());
            }
            return isOk;
          }).toList();
          switch (turmasCalendarioBloc.turmasState) {
            case TurmasCalendarioState.loading:
              return const CircularProgressIndicator.adaptive();
            case TurmasCalendarioState.synchronizing:
              return listViewTurmas(list);
            case TurmasCalendarioState.syncError:
              return listViewTurmas(list);
            case TurmasCalendarioState.ready:
              return listViewTurmas(list);
            case TurmasCalendarioState.error:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      turmasCalendarioBloc.load();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  const Text('Tentar novamente')
                ],
              );
          }
        });
  }

  Widget listViewTurmas(List<TurmaCalendario> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('Você não tem aula nesse dia.'),
      );
    }
    return ListView.builder(
        clipBehavior: Clip.none,
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return TurmaCardWidget(
            turma: list[index],
          );
        });
  }
}
