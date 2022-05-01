import 'package:flutter/material.dart';
import 'package:e_discente/blocs/turmas.bloc.dart';
import 'package:e_discente/models/turma.model.dart';
import 'package:e_discente/util/toast.util.dart';
import 'widgets/turma.widget.dart';

class TurmasPage extends StatefulWidget {
  const TurmasPage({Key? key, required this.turmasBloc}) : super(key: key);
  final TurmasBloc turmasBloc;
  @override
  _TurmasPageState createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage>
    with AutomaticKeepAliveClientMixin {
  late TurmasBloc _turmasBloc;
  late Stream<TurmasState> _turmasStream;
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
    return StreamBuilder<TurmasState>(
        stream: _turmasStream,
        builder: (BuildContext context, snapshot) {
          switch (_turmasBloc.turmasState) {
            case TurmasState.loading:
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
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
        });
  }

  Widget getListView(List<TurmaModel> turmas) {
    return RefreshIndicator(
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
      onRefresh: () {
        /*Settings.turmas=null;*/

        return _turmasBloc.load(isRefreshIndicator: true);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
