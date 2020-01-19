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
  @override
  void initState() {
    _turmasBloc = TurmasBloc();
    super.initState();
  }

  @override
  void dispose() {
    _turmasBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<TurmaModel>>(
        stream: _turmasBloc.turmaStream,
        builder: (BuildContext context, AsyncSnapshot<List<TurmaModel>> snapshot) {
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
              return RefreshIndicator(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Turma(snapshot.data[index]);
                  },
                ),
                onRefresh: () {
                  return _turmasBloc.load(isRefreshIndicator: true);
                },
              );
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

  @override
  bool get wantKeepAlive => true;
}
