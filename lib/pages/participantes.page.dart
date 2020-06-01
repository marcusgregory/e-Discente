import 'package:flutter/material.dart';
import 'package:uni_discente/models/participantes.model.dart';
import 'package:uni_discente/pages/widgets/participante.widget.dart';
import 'dart:math' as math;

class ParticipantesPage extends StatefulWidget {
  final Future<ParticipantesModel> _participantesFuture;
  final String _idTurma;
  const ParticipantesPage(this._participantesFuture, this._idTurma);
  @override
  _ParticipantesPageState createState() => _ParticipantesPageState();
}

class _ParticipantesPageState extends State<ParticipantesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: FutureBuilder(
            future: widget._participantesFuture,
            builder: (BuildContext context,
                AsyncSnapshot<ParticipantesModel> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container();
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    ParticipantesModel participantesModel = snapshot.data;
                    return CustomScrollView(
                      key: PageStorageKey<String>('participantes:'+widget._idTurma),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context)),
                        SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                                minHeight: 42,
                                maxHeight: 42,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50]
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Docentes',
                                            style:
                                                Theme.of(context).textTheme.body2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Divider(
                                            color: Colors.grey[350],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ))),
                        SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          return ParticipanteWidget(
                              participantesModel.docentes[index]);
                        }, childCount: participantesModel.docentes.length)),
                        SliverPersistentHeader(
                          pinned: true,
                            delegate: _SliverAppBarDelegate(
                                minHeight: 42,
                                maxHeight: 42,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50]
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            'Discentes',
                                            style:
                                                Theme.of(context).textTheme.body2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Divider(
                                            color: Colors.grey[350],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ))),
                                SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          return ParticipanteWidget(
                              participantesModel.discentes[index]);
                        }, childCount: participantesModel.discentes.length))
                      ],
                    );
                  }
                  break;
              }
              return Container();
            }));
  }

  @override
  bool get wantKeepAlive => false;
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
