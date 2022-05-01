import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class Detalhe extends StatefulWidget {
  final String? _img;
  final String? _title;
  final String _date;
  final String? _description;
  final String? _url;
  final int? _id;

  Detalhe(this._img, this._title, this._date, this._description, this._url,
      this._id);

  @override
  _DetalheState createState() => _DetalheState();
}

class _DetalheState extends State<Detalhe> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          actions: <Widget>[
            IconButton(
              icon: Theme.of(context).platform == TargetPlatform.iOS
                  ? const Icon(CupertinoIcons.share)
                  : const Icon(Icons.share),
              onPressed: () {
                Share.share(
                    'Veja esta notícia:\n*${widget._title}*\n${widget._url}');
              },
            )
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Scrollbar(
            child: Container(
              padding: EdgeInsets.only(
                  left: constraints.maxWidth <= 600
                      ? 5.0
                      : MediaQuery.of(context).size.width * 0.20,
                  right: constraints.maxWidth <= 600
                      ? 5.0
                      : MediaQuery.of(context).size.width * 0.20),
              margin: const EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Container(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _getImageNetwork(widget._img),
                        _getBody(
                            widget._title!, widget._date, widget._description),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget _getImageNetwork(url) {
    return Hero(
      child: CachedNetworkImage(
          height: 200,
          imageUrl: kIsWeb
              ? 'https://api.allorigins.win/raw?url=' + Uri.encodeComponent(url)
              : url,
          imageBuilder: (context, imageProvider) => Container(
                height: 200,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
          placeholder: (context, url) =>
              SizedBox(height: 200, child: Image.memory(kTransparentImage))),
      tag: widget._id!,
    );
  }

  Widget _getBody(String tittle, String date, String? description) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTittle(tittle),
          _getDate(widget._date),
          _getDescription(description),
        ],
      ),
    );
  }

  _getTittle(String tittle) {
    return Text(
      tittle,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    );
  }

  _getDate(String date) {
    return Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: Text(
          date,
          style: const TextStyle(fontSize: 10.0, color: Colors.grey),
        ));
  }

  _getDescription(String? description) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Html(
        data: widget._description,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
