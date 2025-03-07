import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';


// ignore: must_be_immutable
class CachedImageWidget extends StatelessWidget {
  final double height;
  final double width;
  ShapeBorder ? shape;
  String imageUrlProvided;

  CachedImageWidget({super.key, required this.height, required this.width, required this.imageUrlProvided, this.shape});
  
  Future<String> getImageUrl(String path) async {
    debugPrint('path: $path');
    final ref = FirebaseStorage.instance.ref().child(path);
    
    return await ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getImageUrl(imageUrlProvided),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Icon(Icons.error);
          }
          return Material(
            clipBehavior: Clip.hardEdge,
            shape: shape ?? CircleBorder(side: BorderSide(color: GlobalStyles.defaultBorder, width: 0.5)),
            child: ClipOval(
              child: SizedBox(
                width: width,
                height: height,
                child: CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset('assets/images/avatar1.png'),
                ),
              )
            )
          );
        },
      );
  }
}