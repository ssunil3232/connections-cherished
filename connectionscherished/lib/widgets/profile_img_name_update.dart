import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/user/connection_detail.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/profile_img_name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ProfileImgNameUpdate extends StatefulWidget {
  String name;
  String img;
  ConnectionType type;
  final Function(dynamic) onUpdate;

  ProfileImgNameUpdate({super.key, required this.name, required this.img, required this.onUpdate, required this.type});
  @override
  ProfileImgNameUpdateState createState() => ProfileImgNameUpdateState();
}

class ProfileImgNameUpdateState extends State<ProfileImgNameUpdate> {
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CachedImageWidget(
          height: 80, 
          width: 80, 
          imageUrlProvided: widget.img
        ),
        Padding(
          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing20, right: GlobalStyles.spacingStates.spacing8),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 200
            ),
            child: Text(
              widget.name,
              style: GlobalStyles.textStyles.textH1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ),
        if(widget.type != ConnectionType.view)
        IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ProfileImgNameDialog(
                  name: widget.name,
                  img: widget.img,
                  onChanged: (value) {
                    setState(() {
                      updateData(value);
                    });
                  }
                );
              }
            );
          },
          icon: SvgPicture.asset(
            'assets/icons/edit_icon.svg', 
            width: 24, 
            height: 24
          ),
        ),
      ]
    );
  }
}
