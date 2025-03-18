import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/profile/profile_img_name_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class ProfileImgNameUpdate extends StatefulWidget {
  AvatarImgSelection avatar;
  bool isEditEnabled = true;
  bool isProfileScreen = false;
  final Function(AvatarImgSelection) onUpdate;

  ProfileImgNameUpdate({super.key, required this.avatar, required this.onUpdate, required this.isEditEnabled, this.isProfileScreen = false});
  @override
  ProfileImgNameUpdateState createState() => ProfileImgNameUpdateState();
}

class ProfileImgNameUpdateState extends State<ProfileImgNameUpdate> {
  @override
  void initState() {
    super.initState();
  }

  void updateData(AvatarImgSelection value) {
    widget.avatar.name = value.name;
    widget.avatar.img = value.img;
    widget.avatar.imgFile = value.imgFile;
    setState(() {
      widget.onUpdate(value);
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
          imageUrlProvided: widget.avatar.img,
          imageFile: widget.avatar.imgFile,
        ),
        Padding(
          padding: EdgeInsets.only(left: GlobalStyles.spacingStates.spacing20, right: GlobalStyles.spacingStates.spacing8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(widget.isProfileScreen)
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: GlobalStyles.spacingStates.spacing8),
                    child: SvgPicture.asset('assets/icons/cheers_icon.svg', width: 32, height: 32),
                  ),
                  Text(
                    'Hello there,',
                    style: GlobalStyles.textStyles.textBody,
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 200
                    ),
                    child: Text(
                      widget.avatar.name,
                      style: GlobalStyles.textStyles.textH1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if(widget.isEditEnabled)
                  IconButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) => MediaQuery.removeViewInsets(
                          context: context,
                          removeBottom: true,
                          child: ProfileImgNameDialog(
                            avatar: widget.avatar,
                            onChanged: (AvatarImgSelection value) {
                              setState(() {
                                updateData(value);
                              });
                            }
                          )
                        )
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/edit_icon.svg', 
                      width: 24, 
                      height: 24
                    ),
                  ),
                ],
              )
            ],
          )
        ),
      ]
    );
  }
}
