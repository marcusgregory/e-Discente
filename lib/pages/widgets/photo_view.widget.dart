import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../settings.dart';

class PhotoViewWidget extends StatelessWidget {
  final String url;
  final String tag;
  const PhotoViewWidget(this.url, {super.key, this.tag = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        title: const Text('Foto de Perfil'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Hero(
            tag: tag == '' ? url : tag,
            child: CachedNetworkImage(
              imageUrl: kIsWeb
                  ? '${Settings.apiURL}/get-image?url=${Uri.encodeComponent(url)}'
                  : url,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.contain)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
