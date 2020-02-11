import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/turmas.bloc.dart';
import 'package:uni_discente/models/turma.model.dart';
import 'package:uni_discente/util/toast.util.dart';
import 'widgets/turma.widget.dart';

class TurmasPage extends StatefulWidget {
  @override
  _TurmasPageState createState() => _TurmasPageState();
}

class _TurmasPageState extends State<TurmasPage>
    with AutomaticKeepAliveClientMixin {
  TurmasBloc _turmasBloc;
  Stream<List<TurmaModel>> _turmasStream;
  @override
  void initState() {
    _turmasBloc = TurmasBloc();
    _turmasStream=_turmasBloc.turmaStream;
    super.initState();
  }

  @override
  void dispose() {
    _turmasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: StreamBuilder<List<TurmaModel>>(
        stream: _turmasStream,
        builder: (BuildContext context, AsyncSnapshot<List<TurmaModel>> snapshot) {
          /*if(Settings.turmas!=null){
            return getListView(Settings.turmas);
          }*/
          switch (snapshot.connectionState) {
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            print('waiting');
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
            print('active');
            if (snapshot.hasData) {
              print('hasDada');
              return getListView(snapshot.data);
            } else if (snapshot.hasError) {
              print('hasError');
              ToastUtil.showToast('${snapshot.error}');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _turmasBloc.load();
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  Text('Tentar novamente')
                ],
              );
            } else {
              print('else');
            }
            break;
          case ConnectionState.done:
            print('done');
            break;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
        },
      ),
    );
  }

Widget getListView(List<TurmaModel> turmas){
  return RefreshIndicator(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: turmas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Turma(turmas[index]);
                  },
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
