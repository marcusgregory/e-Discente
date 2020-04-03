import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:uni_discente/models/boletim.model.dart';
import 'package:uni_discente/pages/widgets/item_nota.widget.dart';
import 'package:uni_discente/stores/boletim.store.dart';

import 'widgets/balao_nota.widget.dart';

class BoletimPage extends StatefulWidget {
  @override
  _BoletimPageState createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage>
    with AutomaticKeepAliveClientMixin {
  Boletim _boletimStore = Boletim();
  @override
  void initState() {
    _boletimStore.loadBoletim();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Observer(builder: (_) {
        final future = _boletimStore.boletim;
        switch (future.status) {
          case FutureStatus.pending:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case FutureStatus.rejected:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _boletimStore.loadBoletim();
                  },
                  icon: Icon(Icons.refresh),
                ),
                Text('Tentar novamente')
              ],
            );
            break;
          case FutureStatus.fulfilled:

            // print(future.result[_boletimStore.valores[_boletimStore.index]]);
            return Column(
              children: <Widget>[
                myDropDownButtonBuilder(future.result),
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Divider(
                    color: Colors.black45,
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: future
                          .result[_boletimStore.valores[_boletimStore.index]]
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return myExpansionTile(future.result[
                            _boletimStore.valores[_boletimStore.index]][index]);
                      },
                    ),
                  ),
                )
              ],
            );
        }
        return Container();
      }),
    );
  }

  Widget myDropDownButtonBuilder(var result) {
    return Container(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      padding: EdgeInsets.only(left: 10, right: 10,top: 10),
      child: ListTile(
        title: Text('Semestre',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
              trailing: DropdownButton(
            items: Map.from(result).keys.map((dropDownStringItem) {
              _boletimStore.addValor(dropDownStringItem);
              return DropdownMenuItem<String>(
                value: dropDownStringItem,
                child: Text(dropDownStringItem),
              );
            }).toList(),
            value: _boletimStore.index == null
                ? _boletimStore.valores.first
                : _boletimStore.valores[_boletimStore.index],
            onChanged: (value) {
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
        leading: BalaoNota(boletim.resultado),
        title: Text(
          boletim.disciplina,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(boletim.codigo),
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
            child: Divider(
              color: Colors.black38,
            ),
          ),
          ItemNota('Nota 1', boletim.nota1.isEmpty ? '-' : boletim.nota1),
          ItemNota('Nota 2', boletim.nota2.isEmpty ? '-' : boletim.nota2),
          ItemNota('Nota 3', boletim.nota3.isEmpty ? '-' : boletim.nota3),
          if (boletim.nota4.isNotEmpty)
            ItemNota('Nota 4', boletim.nota4.isEmpty ? '-' : boletim.nota4),
          if (boletim.nota5.isNotEmpty)
            ItemNota('Nota 5', boletim.nota5.isEmpty ? '-' : boletim.nota5),
          if (boletim.recuperacao.isNotEmpty)
            ItemNota('Avaliação Final',
                boletim.recuperacao.isEmpty ? '-' : boletim.recuperacao),
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
            child: Divider(
              color: Colors.black38,
            ),
          ),
          ItemNota('Resultado Final', boletim.resultado),
          SizedBox(
            height: 4,
          )
        ],
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
