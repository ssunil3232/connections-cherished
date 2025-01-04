import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/profile_update.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  String name;
  String img;
  final Function(dynamic) onUpdate;

  Profile({super.key, required this.name, required this.img, required this.onUpdate});
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  void updateData(value) {
    widget.name = value["name"];
    widget.img = value["img"];
    setState(() {
      widget.onUpdate({'name': widget.name, 'img': widget.img});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Expanded(
          //     child:
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.only(top: 20),
            width: 300,
            height: 50,
            child: Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xffB350E1),
                fontSize: 30,
                height: 0.9
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Stack(
            clipBehavior: Clip.none, 
            alignment: Alignment.bottomRight,
            children: [
              CachedImageWidget(
                height: 100, 
                width: 150, 
                imageUrlProvided: widget.img
              ),
              Positioned(
                right:-10, // Adjust this value to move the button closer or further from the right edge
                bottom:-10, // Adjust this value to move the button closer or further from the top
                child: IconButton(
                  // style: ButtonStyle(
                  //   // overlayColor: WidgetStateProperty.all(Colors.transparent),
                  // ),
                  icon: VariedIcon.varied(Symbols.edit,color: GlobalStyles.brandColor1),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ProfileUpdate(
                              name: widget.name,
                              img: widget.img,
                              onChanged: (value) {
                                setState(() {
                                  updateData(value);
                                });
                              });
                        });
                  },
                ),
              ),
            ],
          )
        ]);
  }
}
