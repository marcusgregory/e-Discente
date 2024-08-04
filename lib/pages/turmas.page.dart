import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:e_discente/blocs/turmas.bloc.dart';
import 'package:e_discente/models/turma.model.dart';
import 'package:e_discente/util/toast.util.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/turma.widget.dart';
import 'widgets/user_appbar.widget.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage(
      {Key? key, required this.turmasBloc, this.showProfileMenu = true})
      : super(key: key);
  final TurmasBloc turmasBloc;
  final bool showProfileMenu;
  @override
  _TurmasPageState createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage>
    with AutomaticKeepAliveClientMixin {
  late TurmasBloc _turmasBloc;
  late Stream<TurmasState> _turmasStream;
  List<TurmaModel> turmasFake = List.generate(
      8,
      (index) => TurmaModel(
          idTurma: '0000',
          codigo: '000000',
          docente: 'Docente da Silva Alves',
          horario: '000000',
          local: 'Campus da Universidade II',
          nomeTurma: 'Turma de Teste II'));

  @override
  void initState() {
    _turmasBloc = widget.turmasBloc;
    _turmasStream = widget.turmasBloc.turmaStream;
    if (_turmasBloc.firstRun) {
      _turmasBloc.load();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: widget.showProfileMenu
          ? userAppBar(title: 'Turmas', context: context)
          : AppBar(
              title: const Text('Turmas'),
            ),
      body: SafeArea(
        child: StreamBuilder<TurmasState>(
            stream: _turmasStream,
            builder: (BuildContext context, snapshot) {
              switch (_turmasBloc.turmasState) {
                case TurmasState.loading:
                  return Skeletonizer(
                      enabled: true, child: getListView(turmasFake));
                case TurmasState.ready:
                  return getListView(_turmasBloc.list);
                case TurmasState.error:
                  ToastUtil.showShortToast('${snapshot.error}');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          _turmasBloc.load();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      const Text('Tentar novamente')
                    ],
                  );
              }
            }),
      ),
    );
  }

  Widget getListView(List<TurmaModel> turmas) {
    return RefreshIndicator.adaptive(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad
          },
        ),
        child: Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            key: const PageStorageKey('turmas'),
            scrollDirection: Axis.vertical,
            itemCount: turmas.length,
            itemBuilder: (BuildContext context, int index) {
              return Turma(turmas[index]);
            },
          ),
        ),
      ),
      onRefresh: () {
        /*Settings.turmas=null;*/

        return _turmasBloc.load(isRefreshIndicator: false);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
