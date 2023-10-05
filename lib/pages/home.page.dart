import 'dart:ui';

import 'package:e_discente/blocs/saldo.bloc.dart';
import 'package:e_discente/blocs/turmas_calendario.bloc.dart';
import 'package:e_discente/pages/tarefas.page.dart';
import 'package:e_discente/pages/widgets/card_ru.dart';
import 'package:e_discente/pages/widgets/cicle_avatar.widget.dart';
import 'package:e_discente/pages/widgets/portal_atividades.widget.dart';
import 'package:e_discente/pages/widgets/sync.widgets.dart';
import 'package:e_discente/pages/widgets/story_item.widget.dart.dart';
import 'package:e_discente/pages/widgets/turmas_calendario.widget.dart';
import 'package:e_discente/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../blocs/portal.bloc.dart';
import '../util/toast.util.dart';
import 'turmas_semana.page.dart';

class HomePage extends StatelessWidget {
  static const double radius = 63;
  final SaldoBloc _saldoBloc = SaldoBloc()..load();
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
                  'Olá, ${toBeginningOfSentenceCase(Settings.usuario?.nome.split(' ')[0].toLowerCase())}',
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
      child: RefreshIndicator.adaptive(
        onRefresh: () {
          return Future.wait([
            _portalBloc.load(),
            _turmasCalendarioBloc.load(),
            _saldoBloc.load()
          ]);
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad
            },
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
                        Text('MEU SALDO',
                            style: GoogleFonts.darkerGrotesque(
                                fontSize: 18, fontWeight: FontWeight.w900)),
                      ],
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
                  stream: _saldoBloc.saldoStream,
                  builder: (context, snapshot) {
                    switch (_saldoBloc.saldoState) {
                      case SaldoState.initial:
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        );
                      case SaldoState.loading:
                        return SliverToBoxAdapter(
                          child: Skeletonizer(
                              enabled: true,
                              child: CardRu(saldo: '00,00', reload: () {})),
                        );
                      case SaldoState.ready:
                        return SliverToBoxAdapter(
                          child: CardRu(
                              saldo: _saldoBloc.saldo, reload: _saldoBloc.load),
                        );

                      case SaldoState.error:
                        ToastUtil.showShortToast('${snapshot.error}');
                        return SliverToBoxAdapter(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  _saldoBloc.load();
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                              const Text('Tentar novamente')
                            ],
                          ),
                        );
                      case SaldoState.loadingInitial:
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          ),
                        );
                    }
                  }),
            ),
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
                                builder: (context) => TurmasSemanaPage(
                                      turmasCalendario: _turmasCalendarioBloc,
                                    )));
                      },
                      child: Text('Ver todas',
                          style: GoogleFonts.darkerGrotesque(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
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
                        return TurmasCalendarioWidget(
                            list: _turmasCalendarioBloc.list);
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
                      case TurmasCalendarioState.synchronizing:
                        return TurmasCalendarioWidget(
                          list: _turmasCalendarioBloc.list,
                          isSync: true,
                        );
                      case TurmasCalendarioState.syncError:
                        return TurmasCalendarioWidget(
                          list: _turmasCalendarioBloc.list,
                          isSync: false,
                          isError: true,
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
                                visible: _portalBloc.portalState ==
                                        PortalState.ready &&
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
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TarefasPage(
                                      portalBloc: _portalBloc,
                                    )));
                      },
                      child: Text('Ver todas',
                          style: GoogleFonts.darkerGrotesque(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? const Color(0xFF0D294D)
                                  : null,
                              fontSize: 18,
                              fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: _portalBloc.portalStream,
                  builder: (context, snapshot) {
                    if (_portalBloc.portalState == PortalState.synchronizing) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: SynchronizingWidget(),
                      );
                    } else if (_portalBloc.portalState ==
                        PortalState.syncError) {
                      return const Padding(
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          child: SyncErrorWidget());
                    } else {
                      return const SizedBox(
                        height: 26,
                      );
                    }
                  }),
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
                        return PortalAtividadesWidget(
                            atividades: _portalBloc.portal!.atividades
                                .where((element) => element.daysLeft > 0)
                                .toList());
                      } else {
                        return const PortalAtividadesWidget(
                          atividades: [],
                        );
                      }

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
                    case PortalState.synchronizing:
                      if (_portalBloc.portal != null) {
                        return PortalAtividadesWidget(
                            atividades: _portalBloc.portal!.atividades
                                .where((element) => element.daysLeft > 0)
                                .toList());
                      } else {
                        return const PortalAtividadesWidget(
                          atividades: [],
                        );
                      }
                    case PortalState.syncError:
                      if (_portalBloc.portal != null) {
                        return PortalAtividadesWidget(
                            atividades: _portalBloc.portal!.atividades);
                      } else {
                        return const PortalAtividadesWidget(
                          atividades: [],
                        );
                      }
                  }
                })
          ]),
        ),
      ),
    );
  }
}
