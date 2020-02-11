import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share/share.dart';
import 'package:uni_discente/util/toast.util.dart';
import 'package:url_launcher/url_launcher.dart';

class Detalhe extends StatefulWidget {
  final String _img;
  final String _title;
  final String _date;
  final String _description;
  final String _url;

  Detalhe(this._img, this._title, this._date, this._description, this._url);

  @override
  _DetalheState createState() => _DetalheState();
}

class _DetalheState extends State<Detalhe> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                  'Veja esta notícia:\n*${widget._title}*\n${widget._url}');
            },
          )
        ],
      ),
      body: new Container(
        margin: new EdgeInsets.all(5.0),
        child: new Material(
          elevation: 2.0,
          borderRadius: new BorderRadius.circular(6.0),
          child: new ListView(
            children: <Widget>[
              _getImageNetwork(widget._img),
              _getBody(widget._title, widget._date, widget._description),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getImageNetwork(url) {
    return Hero(
      child: new Container(
          height: 200.0, child: new Image.network(url, fit: BoxFit.cover)),
      tag: widget._url,
    );
  }

  Widget _getBody(String tittle, String date, String description) {
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Column(
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
    return new Text(
      tittle,
      style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
    );
  }

  _getDate(String date) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: new Text(
          date,
          style: new TextStyle(fontSize: 10.0, color: Colors.grey),
        ));
  }

  _getDescription(String description) {
    return new Container(
      margin: new EdgeInsets.only(top: 20.0),
      child: new Html(
        data: this.widget._description,
        defaultTextStyle: TextStyle(fontSize: 16.5),
        onLinkTap: (url) async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            ToastUtil.showToast('Não foi possível abrir a url: $url');
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
