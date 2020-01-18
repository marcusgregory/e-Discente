import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Turma extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(
            left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        elevation: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/turma_item_list.png',
                width: 60,
                height: 60,
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
                      'ADMINISTRAÇÃO E GESTÃO DE PROJETOS',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2.5),
                    Row(
                      children: <Widget>[
                        Icon(Icons.assignment_ind),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text('LUIZ DE ARAÚJO JÚNIOR',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(color: Colors.grey[600])),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.5),
                    Row(
                      children: <Widget>[
                        Icon(Icons.account_balance),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text('Palmares II - Sala 212',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(color: Colors.grey[600])),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.5),
                    Row(
                      children: <Widget>[
                        Icon(Icons.date_range),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text('2M1234',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(color: Colors.grey[600])),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
