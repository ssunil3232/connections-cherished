import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// ignore: must_be_immutable
class CachedImageWidget extends StatelessWidget {
  final double height;
  final double width;
  String imageUrlProvided;

  CachedImageWidget({super.key, required this.height, required this.width, required this.imageUrlProvided});


  @override
  Widget build(BuildContext context) {
    return Material(
            clipBehavior: Clip.hardEdge,
            shape: CircleBorder(side: BorderSide(color: GlobalStyles.cardBorderDefault, width: 0.5)),
            child: ClipOval(
              child: SizedBox(
                width: width,
                height: height,
                child: CachedNetworkImage(
                  imageUrl: imageUrlProvided,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset('assets/images/profile.png'),
                ),
              )
            )
          );
  }
}