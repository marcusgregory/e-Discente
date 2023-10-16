import 'package:e_discente/models/portal.model.dart';
import 'package:e_discente/pages/widgets/tarefa.widget.dart';
import 'package:flutter/material.dart';

import 'package:e_discente/blocs/portal.bloc.dart';

class TarefasPage extends StatelessWidget {
  final PortalBloc portalBloc;
  const TarefasPage({
    Key? key,
    required this.portalBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as Tarefas'),
      ),
      body: StreamBuilder(
          stream: portalBloc.portalStream,
          builder: (context, snapshot) {
            var list = portalBloc.portal?.atividades ?? [];
            list.sort();
            switch (portalBloc.portalState) {
              case PortalState.initial:
                return const CircularProgressIndicator.adaptive();
              case PortalState.loading:
                return const CircularProgressIndicator.adaptive();
              case PortalState.synchronizing:
                return listAtividades(list);
              case PortalState.syncError:
                return listAtividades(list);
              case PortalState.ready:
                return listAtividades(list);
              case PortalState.error:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        portalBloc.load();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    const Text('Tentar novamente')
                  ],
                );
            }
          }),
    );
  }

  Widget listAtividades(List<Atividade> tarefas) {
    if (tarefas.isEmpty) {
      return const Center(
        child: Text('Parece que você não tem atividades pendentes.'),
      );
    }
    return ListView.builder(
        clipBehavior: Clip.none,
        padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
        itemCount: tarefas.length,
        itemBuilder: (ctx, index) {
          return TarefaWidget(atividade: tarefas[index]);
        });
  }
}
