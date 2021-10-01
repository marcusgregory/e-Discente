// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:e_discente/repositories/download.service.dart';
import 'package:e_discente/models/documento.model.dart';
import 'package:e_discente/util/toast.util.dart';
import 'package:url_launcher/url_launcher.dart';

class ConteudoPage extends StatelessWidget {
  const ConteudoPage(this._numero, this._titulo, this._conteudo,
      this._documentos, this.idTurma);
  final String _numero;
  final String _titulo;
  final String _conteudo;
  final String idTurma;
  final List<DocumentoModel> _documentos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$_numero° Conteúdo'),
        ),
        body: Container(
            child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      elevation: 2.0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Center(
                              child: Text(
                                _titulo,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 16),
                              child: Divider()),
                          _conteudo.isNotEmpty
                              ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Html(
                                        data: _conteudo,
                                        defaultTextStyle:
                                            TextStyle(fontSize: 14),
                                        onLinkTap: (url) async {
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            ToastUtil.showShortToast(
                                                'Não foi possível abrir a url: $url');
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Center(
                                    child: Text('Sem conteúdo'),
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
                ]),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    elevation: 2.0,
                    child: InkWell(
                      onTap: () {
                        DownloadService(context)
                            .downloadDocumento(idTurma, _documentos[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 3, right: 3, bottom: 6, top: 6),
                        child: ListTile(
                          leading:
                              balaoArquivo(_documentos[index].nome, context),
                          title: Text(_documentos[index].nome,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ),
                );
              }, childCount: _documentos.length)),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: 20,
                  )
                ]),
              )
            ],
          ),
        )));
  }

  Widget balaoArquivo(String tipo, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 45.0,
          height: 45.0,
          decoration: BoxDecoration(
            color:
                tipo.toLowerCase().contains('.pdf') ? Colors.red : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        IconButton(
            icon: Icon(
              tipo.toLowerCase().contains('.pdf')
                  ? Icons.picture_as_pdf
                  : Icons.insert_drive_file,
              color: Colors.white,
            ),
            onPressed: null)
      ],
    );
  }
}
