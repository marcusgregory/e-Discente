
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:unidiscente/models/noticias.model.dart';

class Noticia extends StatelessWidget{

 NoticiaModel noticia;

  Noticia(this.noticia);

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;

    //Foi adicionado dentro de Container para adicionar margem no item
    return  Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(left: 10.0, right: 10.0,bottom: 10.0,top: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0)),
          elevation: 2.0,
          child: _getListTile(),
        ),
    );
  }

  Widget _getListTile(){

    // Foi adicionado dentro de Container para adicionar altura fixa.
    return new Container(
      
      height: 95.0,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          _loadImage(),          
          _getColumText(this.noticia.titulo,this.noticia.data,this.noticia.resumo),
      ],

    ),
    );

  }

  Widget _getColumText(title,date, description){

    return new Expanded(
        child: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: <Widget>[
              _getTitleWidget(title),
              _getDateWidget(date),
              _getDescriptionWidget(description)],
          ),
        )
    );
  }

  Widget _getTitleWidget(String curencyName){
    return new Text(
      curencyName,
      maxLines: 1,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _getDescriptionWidget(String description){
    return new Container(
      margin: new EdgeInsets.only(top: 5.0),
      child: new Text(description,maxLines: 2,),
    );
  }

  Widget _getDateWidget(String date){
    return new Text(date,
      style: new TextStyle(color: Colors.grey,fontSize: 10.0),);
  }
Widget _loadImage(){
  return Container(
    child: new FadeInImage( 
      image:Image.network(this.noticia.imagem).image, fit: BoxFit.cover,width: 95.0,height: 95.0, placeholder: Image.memory(kTransparentImage).image,),
  );
 
}
}