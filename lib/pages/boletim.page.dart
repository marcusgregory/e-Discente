import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:e_discente/models/boletim.model.dart';
import 'package:e_discente/pages/widgets/item_nota.widget.dart';
import 'package:e_discente/stores/boletim.store.dart';

import 'widgets/balao_nota.widget.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({Key? key, required this.boletimStore}) : super(key: key);
  final Boletim boletimStore;
  @override
  _BoletimPageState createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage>
    with AutomaticKeepAliveClientMixin {
  late Boletim _boletimStore;
  @override
  void initState() {
    _boletimStore = widget.boletimStore;
    if (_boletimStore.firstRun) _boletimStore.loadBoletim();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Observer(builder: (_) {
        final future = _boletimStore.boletim!;
        switch (future.status) {
          case FutureStatus.pending:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          case FutureStatus.rejected:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _boletimStore.loadBoletim();
                  },
                  icon: const Icon(Icons.refresh),
                ),
                const Text('Tentar novamente')
              ],
            );
          case FutureStatus.fulfilled:

            // print(future.result[_boletimStore.valores[_boletimStore.index]]);
            return Scrollbar(
              child: ListView(
                key: const PageStorageKey('Boletim-header'),
                children: <Widget>[
                  myDropDownButtonBuilder(future.result),
                  const Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(
                      color: Colors.black45,
                    ),
                  ),
                  ListView.builder(
                    key: const PageStorageKey('Boletim'),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: future
                        .result[_boletimStore.valores[_boletimStore.index]]
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return myExpansionTile(future.result[
                          _boletimStore.valores[_boletimStore.index]][index]);
                    },
                  )
                ],
              ),
            );
        }
      }),
    );
  }

  Widget myDropDownButtonBuilder(var result) {
    return Container(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ListTile(
        title: const Text(
          'Semestre',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        trailing: DropdownButton(
            items: Map.from(result).keys.map((dropDownStringItem) {
              _boletimStore.addValor(dropDownStringItem);
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            value: _boletimStore.valores[_boletimStore.index],
            onChanged: (dynamic value) {
              _boletimStore.setIdex(_boletimStore.valores.indexOf(value));
            }),
      ),
    );
  }

  Widget myExpansionTile(BoletimModel boletim) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin:
          const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      elevation: 2.0,
      child: ExpansionTile(
        key: PageStorageKey(boletim.codigo),
        leading: BalaoNota(boletim.resultado!),
        title: Text(
          boletim.disciplina!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(boletim.codigo!),
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
            child: Divider(
              color: Colors.black38,
            ),
          ),
          ItemNota('Nota 1', boletim.nota1!.isEmpty ? '-' : boletim.nota1!),
          ItemNota('Nota 2', boletim.nota2!.isEmpty ? '-' : boletim.nota2!),
          ItemNota('Nota 3', boletim.nota3!.isEmpty ? '-' : boletim.nota3!),
          if (boletim.nota4!.isNotEmpty)
            ItemNota('Nota 4', boletim.nota4!.isEmpty ? '-' : boletim.nota4!),
          if (boletim.nota5!.isNotEmpty)
            ItemNota('Nota 5', boletim.nota5!.isEmpty ? '-' : boletim.nota5!),
          if (boletim.recuperacao!.isNotEmpty)
            ItemNota('Avaliação Final',
                boletim.recuperacao!.isEmpty ? '-' : boletim.recuperacao!),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
            child: Divider(
              color: Colors.black38,
            ),
          ),
          ItemNota('Resultado Final', boletim.resultado!),
          const SizedBox(
            height: 4,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
