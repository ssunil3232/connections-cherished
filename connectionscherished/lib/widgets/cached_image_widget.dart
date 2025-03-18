import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectionscherished/services/providers/profile_img_provider.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CachedImageWidget extends StatelessWidget {
  final double height;
  final double width;
  ShapeBorder ? shape;
  String imageUrlProvided;
  File ? imageFile;

  CachedImageWidget({super.key, required this.height, required this.width, required this.imageUrlProvided, this.shape, this.imageFile});

  @override
  Widget build(BuildContext context) {
    String imgPath = Provider.of<ProfileImgProvider>(context).imageUrls[imageUrlProvided] ?? '';
    return (imageFile != null)
    ? Material(
      clipBehavior: Clip.antiAlias,
      shape: shape ?? CircleBorder(side: BorderSide(color: GlobalStyles.defaultBorder, width: 0.5)),
      child: Image.file(
        imageFile!,
        height: height,
        width: width,
        fit: BoxFit.fill,
      )
    )
    :
    (imgPath.isEmpty)
    ? CircularProgressIndicator()
    : Material(
      clipBehavior: Clip.antiAlias,
      shape: shape ?? CircleBorder(side: BorderSide(color: GlobalStyles.defaultBorder, width: 0.5)),
      child: CachedNetworkImage(
        height: height,
        width: width,
        fit: BoxFit.fill,
        imageUrl: imgPath,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => Image.asset('assets/images/avatar1.png'),
      )
    );
  }
}