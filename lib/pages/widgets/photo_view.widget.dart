import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoViewWidget extends StatelessWidget {
  final String url;
  const PhotoViewWidget(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foto de Perfil'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Hero(
            child: CachedNetworkImage(
              imageUrl: this.url,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain)),
                );
              },
            ),
            tag: url,
          ),
        ),
      ),
    );
  }
}
