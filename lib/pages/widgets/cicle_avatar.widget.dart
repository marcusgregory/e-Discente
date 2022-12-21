import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_discente/pages/widgets/photo_view.widget.dart';
import 'package:flutter/material.dart';

class CicleAvatarWidget extends StatelessWidget {
  final String url;
  final double radius;
  const CicleAvatarWidget({Key? key, required this.url, this.radius = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: Image.asset('assets/profile_pic.png').image,
                    fit: BoxFit.cover),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: Image.asset('assets/profile_pic.png').image,
                    fit: BoxFit.cover),
              ),
            );
          },
          imageBuilder: (context, imageProvider) => Hero(
            tag: url,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return PhotoViewWidget(url, tag: url);
                }));
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ));
  }
}
