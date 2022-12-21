import 'package:flutter/material.dart';
import 'package:e_discente/models/participantes.model.dart';
import 'package:e_discente/pages/aulas.page.dart';
import 'package:e_discente/pages/notas_turma.page.dart';
import 'package:e_discente/pages/participantes.page.dart';
import 'package:e_discente/repositories/participantes.repository.dart';
import 'package:e_discente/stores/aulas.store.dart';

class TurmaPage extends StatefulWidget {
  final String? _titulo;
  final String? _idTurma;

  const TurmaPage(this._titulo, this._idTurma);

  @override
  _TurmaPageState createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //TabController _tabController;
  late ScrollController _scrollViewController;
  final Aulas _aulasStore = Aulas();
  Future<ParticipantesModel>? _participantesFuture;

  @override
  void initState() {
    super.initState();
    //  _tabController = TabController(length: 3, vsync: this);
    _scrollViewController = ScrollController();
    inicio();
  }

  @override
  void dispose() {
    // _tabController.dispose();
    _scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      title: Text(
                        widget._titulo!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                      pinned: true,
                      floating: true,
                      snap: true,
                      primary: true,
                      forceElevated: boxIsScrolled,
                      bottom: const TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(
                            text: 'CONTEÚDOS',
                          ),
                          Tab(
                            text: 'PARTICIPANTES',
                          ),
                          Tab(
                            text: 'NOTAS',
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ];
            },
            body: TabBarView(
              children: [
                AulasPage(_aulasStore, widget._idTurma),
                ParticipantesPage(_participantesFuture, widget._idTurma),
                NotasTurmaPage(widget._idTurma)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> inicio() async {
    _aulasStore.loadAulas(widget._idTurma);
    _participantesFuture =
        ParticipantesRepository().getParticipantes(widget._idTurma);
  }
}
