import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final String url;
  final double radius;
  const StoryCircle({Key? key, required this.url, this.radius = 54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: radius,
          height: radius,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.greenAccent,
                  Colors.deepPurpleAccent,
                ],
              )),
        ),
        Container(
          width: radius - 4,
          height: radius - 4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0D294D),
          ),
        ),
        SizedBox(
          width: radius - 9,
          height: radius - 9,
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
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
