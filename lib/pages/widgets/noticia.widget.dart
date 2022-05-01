import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:e_discente/models/noticias.model.dart';
import 'package:e_discente/presentation/custom_icons_icons.dart';
import 'package:e_discente/util/toast.util.dart';
import 'package:e_discente/util/date.util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../detalhes_screen.page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Noticia extends StatelessWidget {
  final NoticiaModel noticia;

  const Noticia({Key? key, required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10.0, top: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      elevation: 2.0,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detalhe(
                        noticia.imagem,
                        noticia.titulo,
                        DateUtil.getTimeElapsedByDate(noticia.data!),
                        noticia.conteudo,
                        noticia.url,
                        noticia.id)));
          },
          child: _getListTile(context)),
    );
  }

  Widget _getListTile(context) {
    // Foi adicionado dentro de Container para adicionar altura fixa.
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _loadImage(),
            _getColumText(this.noticia.titulo, this.noticia.data,
                this.noticia.resumo, context),
          ],
        ),
        Row(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  height: 25,
                  width: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Image.asset('assets/logo_unilab.png'),
                  )),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Unilab  •  ${DateUtil.getTimeElapsedByDate(this.noticia.data!)}',
              style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyText1!.color),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: TextButton(
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? Icon(
                            Icons.more_horiz,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            size: 20,
                          )
                        : Icon(
                            Icons.more_vert,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            size: 20,
                          ),
                    onPressed: () {
                      _showModalBottomSheet(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _getColumText(title, date, description, context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getTitleWidget(title, context),
          _getDescriptionWidget(description, context),
        ]);
  }

  Widget _getTitleWidget(String curencyName, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
      child: Text(
        curencyName,
        maxLines: 4,
        style: new TextStyle(
            fontSize: 17.9,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textTheme.bodyText1!.color),
      ),
    );
  }

  Widget _getDescriptionWidget(String description, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
      child: Text(
        description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style:
            new TextStyle(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
    );
  }

  /* Widget _getDateWidget(String date) {
    return new Text(
      date,
      style: new TextStyle(color: Colors.grey, fontSize: 10.0),
    );
  }
*/
  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    height: 50,
                    child: InkWell(
                      onTap: () => Share.share(
                          'Veja esta notícia:\n${this.noticia.titulo}\n${this.noticia.url}'),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 17,
                          ),
                          Icon(Icons.share, size: 20, color: Colors.grey[600]),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Compartilhar',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      if (Platform.isIOS) {
                        String url =
                            'https://wa.me/?text=Veja esta notícia:\n*${this.noticia.titulo}*\n${this.noticia.url}';
                        url = Uri.encodeFull(url);
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          ToastUtil.showShortToast(
                              "Não foi possível abrir o WhatsApp\nEstá instalado no seu IOS?");
                        }
                      } else {
                        String url =
                            'https://wa.me/?text=Veja esta notícia:\n*${this.noticia.titulo}*\n${this.noticia.url}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 17,
                        ),
                        Icon(CustomIcons.whatsapp,
                            size: 20, color: Colors.grey[600]),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Enviar via WhatsApp',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  child: InkWell(
                    onTap: () async {
                      String url = noticia.url!;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ToastUtil.showShortToast(
                            'Não foi possível abrir a url: $url');
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 17,
                        ),
                        Icon(Icons.open_in_browser,
                            size: 20, color: Colors.grey[600]),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Abrir no Navegador',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Divider(),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    style: ButtonStyle(),
                    child: Text(
                      "Fechar",
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _loadImage() {
    return Hero(
      tag: noticia.id!,
      child: CachedNetworkImage(
          height: 185,
          width: 185,
          imageUrl: kIsWeb
              ? 'https://api.allorigins.win/raw?url=' +
                  Uri.encodeComponent(this.noticia.imagem!)
              : this.noticia.imagem!,
          imageBuilder: (context, imageProvider) => Container(
                width: 185,
                height: 185,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
          placeholder: (context, url) => Container(
              height: 185, width: 185, child: Image.memory(kTransparentImage))),
    );

    /*new FadeInImage( 
        image: Image.network(this.noticia.imagem).image,
        fit: BoxFit.cover,
        width: 185.0,
        height: 185.0,
        placeholder: Image.memory(kTransparentImage).image,
      ),
      */
  }
}
