import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../settings.dart';
import 'dialog_account.widget.dart';

PreferredSizeWidget userAppBar(
    {required String title, required BuildContext context}) {
  return AppBar(
    systemOverlayStyle:
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    elevation: 1.0,
    actions: <Widget>[
      IconButton(
        icon: Hero(
          tag: 'icon_book',
          child: CircleAvatar(
            radius: 13,
            backgroundColor: Colors.transparent,
            child: CachedNetworkImage(
              imageUrl: kIsWeb
                  ? 'https://api.allorigins.win/raw?url=' +
                      Uri.encodeComponent(Settings.usuario!.urlImagemPerfil!)
                  : Settings.usuario!.urlImagemPerfil!,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => Icon(
                Icons.account_circle,
                color: Colors.grey[200],
              ),
              errorWidget: (context, url, error) =>
                  Icon(Icons.account_circle, color: Colors.grey[200]),
            ),
          ),
        ),
        onPressed: () async {
          // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          //   return DialogAccount();
          // }));
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // ignore: prefer_const_constructors
                  child: DialogAccount());
            },
          );
        },
      ),
    ],
  );
}
