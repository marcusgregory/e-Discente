import 'package:e_discente/blocs/turmas_calendario.bloc.dart';
import 'package:e_discente/pages/widgets/cicle_avatar.widget.dart';
import 'package:e_discente/pages/widgets/story_item.widget.dart.dart';
import 'package:e_discente/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../blocs/portal.bloc.dart';
import '../blocs/turmas.bloc.dart';
import '../models/turma_calendario.model.dart';
import '../util/toast.util.dart';
import 'turma.page.dart';
import 'turmas.page.dart';
import 'widgets/tarefa.widget.dart';

class HomePage extends StatelessWidget {
  static const double radius = 63;
  final TurmasCalendarioBloc _turmasCalendarioBloc = TurmasCalendarioBloc()
    ..load();
  final PortalBloc _portalBloc = PortalBloc()..load();
  static const itens = [
    StoryCircle(
        radius: radius,
        url:
            'https://pt.org.br/wp-content/uploads/2022/06/chamada-jornal-pt-brasil-enio-verri-585x390.jpg'),
    StoryCircle(
        radius: radius,
        url:
            'https://portal.fazenda.sp.gov.br/Noticias/PublishingImages/NFP%20Bilhetes%20de%20jun22.png?RenditionID=8'),
    StoryCircle(
        radius: radius,
        url:
            'https://files.nsctotal.com.br/s3fs-public/graphql-upload-files/whats.JPG?N2s9zmzC3j_bH0opGFl6oLZfYxivwzd0'),
    StoryCircle(
        radius: radius,
        url:
            'https://cna.com.br/Content/uploads/blogposts/os-melhores-sites-de-noticias-em-ingles-para-estudar.jpg'),
    StoryCircle(
        radius: radius,
        url: 'https://i.ytimg.com/vi/3hxMSZP9tjI/maxresdefault.jpg'),
    StoryCircle(
        radius: radius,
        url:
            'https://pt.org.br/wp-content/uploads/2022/06/chamada-jornal-pt-brasil-enio-verri-585x390.jpg'),
    StoryCircle(
        radius: radius,
        url:
            'https://portal.fazenda.sp.gov.br/Noticias/PublishingImages/NFP%20Bilhetes%20de%20jun22.png?RenditionID=8'),
    StoryCircle(
        radius: radius,
        url:
            'https://files.nsctotal.com.br/s3fs-public/graphql-upload-files/whats.JPG?N2s9zmzC3j_bH0opGFl6oLZfYxivwzd0'),
    StoryCircle(
        radius: radius,
        url:
            'https://cna.com.br/Content/uploads/blogposts/os-melhores-sites-de-noticias-em-ingles-para-estudar.jpg'),
    StoryCircle(
        radius: radius,
        url: 'https://i.ytimg.com/vi/3hxMSZP9tjI/maxresdefault.jpg'),
  ];
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF0D294D),
        body: SafeArea(
          child: NestedScrollView(
              body: _body(context),
              headerSliverBuilder: (context, value) {
                return [SliverToBoxAdapter(child: _header(context))];
              }),

          //   child: CustomScrollView(
          // slivers: [
          // SliverFillRemaining(
          //   child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         _header(context),
          //         const SizedBox(
          //           height: 15,
          //         ),
          //         _body(context),
          //       ]),
          // )
          // ],
        ));
  }

  Widget _header(BuildContext context) {
    DateTime now = DateTime.now();
    String data = DateFormat("E, d 'de' MMM", 'pt-BR').format(now);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 5),
              child: Text(
                data,
                style: GoogleFonts.darkerGrotesque(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CicleAvatarWidget(
                  radius: 22, url: Settings.usuario?.urlImagemPerfil ?? ''),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Text(
                  'Olá, ${toBeginningOfSentenceCase(Settings.usuario?.nome?.split(' ')[0].toLowerCase())}',
                  maxLines: 2,
                  overflow: TextOverflow
                      .ellipsis, //${toBeginningOfSentenceCase(Settings.usuario?.nome?.split(' ')[0].toLowerCase())}',
                  style: GoogleFonts.darkerGrotesque(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 24, right: 24),
        //   child: Text('DESTAQUES',
        //       style: GoogleFonts.darkerGrotesque(
        //           color: Colors.white,
        //           fontSize: 18,
        //           fontWeight: FontWeight.w800)),
        // ),
        // const SizedBox(
        //   height: 5,
        // ),
        // SizedBox(
        //   height: 70,
        //   child: ListView.separated(
        //     padding: const EdgeInsets.only(left: 24, right: 24),
        //     shrinkWrap: true,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (BuildContext context, int index) {
        //       return itens[index];
        //     },
        //     itemCount: itens.length,
        //     separatorBuilder: (BuildContext context, int index) {
        //       return const SizedBox(
        //         width: 12,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: CustomScrollView(slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('AULAS HOJE',
                        style: GoogleFonts.darkerGrotesque(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(
                      width: 5,
                    ),
                    StreamBuilder(
                        stream: _turmasCalendarioBloc.turmaStream,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible: _turmasCalendarioBloc.turmasState ==
                                    TurmasCalendarioState.ready &&
                                _turmasCalendarioBloc.list.isNotEmpty,
                            child: Text(
                                '(${_turmasCalendarioBloc.list.length})',
                                style: GoogleFonts.darkerGrotesque(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey)),
                          );
                        }),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TurmasPage(
                                  turmasBloc: TurmasBloc(),
                                  showProfileMenu: false,
                                )));
                  },
                  child: Text('Ver todas',
                      style: GoogleFonts.darkerGrotesque(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? const Color(0xFF0D294D)
                                  : null,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 18.7,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          sliver: StreamBuilder(
              stream: _turmasCalendarioBloc.turmaStream,
              builder: (context, snapshot) {
                switch (_turmasCalendarioBloc.turmasState) {
                  case TurmasCalendarioState.loading:
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    );
                  case TurmasCalendarioState.ready:
                    if (_turmasCalendarioBloc.list.isEmpty) {
                      return const SliverToBoxAdapter(
                          child: SizedBox(
                        height: 200,
                        child: Center(
                          child: Text('Parece que você não tem aula hoje'),
                        ),
                      ));
                    }

                    return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      TurmaCalendario turma = _turmasCalendarioBloc.list[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TurmaPage(
                                        turma.nomeTurma, turma.idTurma)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IntrinsicHeight(
                              child: Row(children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SizedBox(
                                    width: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            turma.horariosDefinidos.first
                                                .horarioInicial,
                                            style: GoogleFonts.darkerGrotesque(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900)),
                                        const Icon(
                                          Icons.arrow_drop_down_rounded,
                                          size: 30,
                                        ),
                                        Text(
                                            turma.horariosDefinidos.first
                                                .horarioFinal,
                                            style: GoogleFonts.darkerGrotesque(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900)),
                                      ],
                                    ),
                                  ),
                                ),
                                const VerticalDivider(),
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(turma.nomeTurma,
                                          style: GoogleFonts.darkerGrotesque(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800)),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.pin_drop,
                                            size: 13,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(turma.local,
                                                maxLines: 2,
                                                overflow: TextOverflow.fade,
                                                style:
                                                    GoogleFonts.darkerGrotesque(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.person_pin,
                                            size: 13,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(turma.docente,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    GoogleFonts.darkerGrotesque(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      );
                    }, childCount: _turmasCalendarioBloc.list.length));
                  case TurmasCalendarioState.error:
                    ToastUtil.showShortToast('${snapshot.error}');
                    return SliverToBoxAdapter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              _turmasCalendarioBloc.load();
                            },
                            icon: const Icon(Icons.refresh),
                          ),
                          const Text('Tentar novamente')
                        ],
                      ),
                    );
                }
              }),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('MINHAS TAREFAS',
                        style: GoogleFonts.darkerGrotesque(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(
                      width: 5,
                    ),
                    StreamBuilder(
                        stream: _portalBloc.portalStream,
                        builder: (context, snapshot) {
                          return Visibility(
                            visible:
                                _portalBloc.portalState == PortalState.ready &&
                                    _portalBloc.portal != null,
                            child: Text(
                                '(${_portalBloc.portal?.atividades.length})',
                                style: GoogleFonts.darkerGrotesque(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey)),
                          );
                        }),
                  ],
                ),
                // Text('Ver todas',
                //     style: GoogleFonts.darkerGrotesque(
                //         color: Theme.of(context).brightness == Brightness.light
                //             ? const Color(0xFF0D294D)
                //             : null,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 26,
          ),
        ),
        StreamBuilder(
            stream: _portalBloc.portalStream,
            builder: (context, snapshot) {
              switch (_portalBloc.portalState) {
                case PortalState.initial:
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                case PortalState.loading:
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                case PortalState.ready:
                  if (_portalBloc.portal != null) {
                    if (_portalBloc.portal!.atividades.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                                'Parece que você não tem atividades pendentes.'),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 20),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return TarefaWidget(
                                atividade:
                                    _portalBloc.portal!.atividades[index]);
                          },
                          childCount: _portalBloc.portal!.atividades.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.92,
                        ),
                      ),
                    );
                    // return ListView.separated(
                    //   padding: const EdgeInsets.only(left: 21, right: 0),
                    //   scrollDirection: Axis.horizontal,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Padding(
                    //       padding: const EdgeInsets.only(right: 14),
                    //       child: TarefaWidget(
                    //           atividade:
                    //               _portalBloc.portal!.atividades[index]),
                    //     );
                    //   },
                    //   itemCount: _portalBloc.portal!.atividades.length,
                    //   separatorBuilder: (BuildContext context, int index) {
                    //     return const SizedBox(
                    //       width: 3.5,
                    //     );
                    //   },
                    // );
                  }
                  break;

                case PortalState.error:
                  return SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            _turmasCalendarioBloc.load();
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                        const Text('Tentar novamente')
                      ],
                    ),
                  );
              }
              return SliverToBoxAdapter(child: Container());
            })
      ]),
    );
  }
}
