import 'package:e_discente/models/portal.model.dart';
import 'package:e_discente/util/toast.util.dart';
import 'package:flutter/material.dart';

import 'tarefa.widget.dart';

class PortalAtividadesWidget extends StatelessWidget {
  final List<Atividade> atividades;
  const PortalAtividadesWidget({super.key, required this.atividades});

  @override
  Widget build(BuildContext context) {
    atividades.sort();
    if (atividades.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text('Parece que você não tem atividades pendentes.'),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return InkWell(
              onTap: () {
                ToastUtil.showLongToast(
                    'Acesso a tarefa estará disponível em breve!');
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             WebViewAtividade(atividade: atividades[index])));
              },
              child: TarefaWidget(atividade: atividades[index]));
        }, childCount: atividades.length),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            mainAxisExtent: 180),
      ),
    );
  }
}
