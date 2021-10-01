// @dart=2.9
import 'package:flutter/material.dart';
import 'package:e_discente/models/discente.model.dart';
import 'package:e_discente/pages/widgets/participante.widget.dart';

class DiscentesPage extends StatefulWidget {
  final List<DiscenteModel> discentes;
  DiscentesPage(this.discentes);

  @override
  _DiscentesPageState createState() => _DiscentesPageState();
}

class _DiscentesPageState extends State<DiscentesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: ListView.builder(
        itemCount: widget.discentes.length,
        itemBuilder: (context, position) {
          print(widget.discentes[position].nome);
          return ParticipanteWidget(widget.discentes[position]);
        },
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
