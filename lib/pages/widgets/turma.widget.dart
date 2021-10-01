// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:e_discente/models/turma.model.dart';
import 'package:e_discente/pages/turma.page.dart';

class Turma extends StatelessWidget {
  final TurmaModel turma;

  Turma(this.turma);

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(
            left: 15.0, right: 15.0, bottom: 5.0, top: 5.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        elevation: 2.0,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TurmaPage(turma.nomeTurma, turma.idTurma)));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/turma_item_list.png',
                  width: 50,
                  height: 50,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 8, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        this.turma.nomeTurma,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.assignment_ind,
                            color: Theme.of(context).textTheme.bodyText1.color,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                                this.turma.docente != null
                                    ? this.turma.docente
                                    : 'O docente fechou esta turma',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.account_balance,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              size: 18),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(this.turma.local,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.date_range,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              size: 18),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(this.turma.horario,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.bodyText1.color,
                size: 15,
              ),
              SizedBox(
                width: 12,
              )
            ],
          ),
        ));
  }
}
