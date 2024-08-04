import 'package:e_discente/pages/widgets/sync.widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/turma_calendario.model.dart';
import '../turma.page.dart';

class TurmasCalendarioWidget extends StatelessWidget {
  final List<TurmaCalendario> list;
  final bool isSync;
  final isError;
  const TurmasCalendarioWidget(
      {super.key,
      required this.list,
      this.isSync = false,
      this.isError = false});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return SliverToBoxAdapter(
          child: Column(
        children: [
          Visibility(
            visible: isSync,
            child: const SynchronizingWidget(),
          ),
          Visibility(
            visible: isError,
            child: const SyncErrorWidget(),
          ),
          const SizedBox(
            height: 200,
            child: Center(
              child: Text('Parece que você não tem aula hoje'),
            ),
          ),
        ],
      ));
    }

    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      late TurmaCalendario turma;
      if ((index == 0 && isSync) || (index == 0 && isError)) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Visibility(visible: isSync, child: const SynchronizingWidget()),
              Visibility(visible: isError, child: const SyncErrorWidget())
            ],
          ),
        );
      }
      if (isSync || isError) {
        turma = list[index - 1];
      } else {
        turma = list[index];
      }

      return TurmaCardWidget(turma: turma);
    }, childCount: (isSync || isError) ? list.length + 1 : list.length));
  }
}

class TurmaCardWidget extends StatelessWidget {
  const TurmaCardWidget({
    super.key,
    required this.turma,
  });

  final TurmaCalendario turma;

  @override
  Widget build(BuildContext context) {
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
                  builder: (context) =>
                      TurmaPage(turma.nomeTurma, turma.idTurma)));
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(turma.horariosDefinidos.first.horarioInicial,
                          style: GoogleFonts.darkerGrotesque(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 30,
                      ),
                      Text(turma.horariosDefinidos.first.horarioFinal,
                          style: GoogleFonts.darkerGrotesque(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(turma.nomeTurma,
                        style: GoogleFonts.darkerGrotesque(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              style: GoogleFonts.darkerGrotesque(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              style: GoogleFonts.darkerGrotesque(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
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
  }
}
