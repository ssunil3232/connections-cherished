import 'dart:io';
import 'package:connectionscherished/services/providers/profile_img_provider.dart';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/dialog_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';

class AvatarImgSelection {
  String name;
  String img;
  File? imgFile;

  AvatarImgSelection({required this.name, required this.img, this.imgFile});
}

// ignore: must_be_immutable
class ProfileImgNameDialog extends StatefulWidget {
  ProfileImgNameDialog(
      {super.key,
      required this.avatar,
      required this.onChanged});

  AvatarImgSelection avatar;
  final Function(AvatarImgSelection) onChanged;
  @override
  ProfileImgNameDialogState createState() => ProfileImgNameDialogState();
}

class ProfileImgNameDialogState extends State<ProfileImgNameDialog> {
  bool _allValid = true;
  bool _showNameError = false;
  final RegExp nameRegex = RegExp(r"^[a-zA-Z0-9_\xC0-\uFFFF]+([ \-']{0,1}[a-zA-Z0-9_\xC0-\uFFFF]+){0,2}[.]{0,1}$");
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late String selectedAvatar;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      // Launch the cropper UI for the picked image.
      File? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ),
      );
      // If cropping was successful, update the state with the cropped image.
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
          selectedAvatar = 'assets/images/uploads/${pickedFile.name}';
        });
      } else{
        setState(() {
          _imageFile = File(pickedFile.path);
          selectedAvatar = 'assets/images/uploads/${pickedFile.name}';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.avatar.name;
    _nameController.addListener(_updateState);
    selectedAvatar = widget.avatar.img;
    _imageFile = widget.avatar.imgFile;
  }

  void _updateState() {
    setState(() {
      _allValid = _isNameValid();
    });
  }

  bool _isNameValid() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showNameError = false;
      return false;
    }
    _showNameError = !nameRegex.hasMatch(name);
    return !_showNameError;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DialogWidget(
        confirmTitle: "Save",
        showCustomCancel: true,
        onResponse: (value) {},
        customBody: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputFieldWidget(
              labelText: 'Name',
              controller: _nameController,
            ),
            SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing20)),
            Center(
              child: CachedImageWidget(
                height: GlobalStyles.spacingStates.imageEnlarged, 
                width: GlobalStyles.spacingStates.imageEnlarged, 
                imageUrlProvided: selectedAvatar,
                imageFile: _imageFile,
              ),
            ),
            SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
            Text(
              'Avatar options',
              textAlign: TextAlign.start,
              style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),
            ),
            SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing8)),
            _buildAvatarSection(),
            SizedBox(height: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing16)),
            CustomButtonWidget.secondary(
              text: 'Save',
              onPressed: _allValid ? () {
                if(_allValid){
                  widget.onChanged(
                    AvatarImgSelection(
                      name: _nameController.text, 
                      img: selectedAvatar, 
                      imgFile: _imageFile
                    )
                  );
                  Navigator.of(context).pop();
                }
              }: null
            ),
          ],
        ),
      )
    );
  }

  Widget _buildAvatarSection (){
    Map<String,String> avatarOptions = Provider.of<ProfileImgProvider>(context).imageUrls;
    return Container(
      margin: EdgeInsets.symmetric(vertical: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4)),
      height: GlobalStyles.spacingStates.imageOptions,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildAvatarOption('assets/icons/camera_icon.svg', () => pickImage(ImageSource.camera)),
          _buildAvatarOption('assets/icons/image_upload_icon.svg', () => pickImage(ImageSource.gallery)),
          ...avatarOptions.entries.map(
            (avatar) => GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  selectedAvatar = avatar.key;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4, useWidth: true)),
                child: CachedImageWidget(
                  height: GlobalStyles.spacingStates.imageOptions, 
                  width: GlobalStyles.spacingStates.imageOptions, 
                  imageUrlProvided: avatar.key,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: selectedAvatar == avatar.key ? GlobalStyles.btnBgPrimary : Colors.transparent, 
                      width: 3.0
                    )
                  )
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOption(String icon, VoidCallback onTapFn) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTapFn();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.getSpacing(SpacingConstant.spacing4, useWidth: true)),
        child: CircleAvatar(
          radius: GlobalStyles.spacingStates.imageOptions/2,
          backgroundColor: GlobalStyles.defaultTextBg,
          child: SvgPicture.asset(
            icon, 
            width: GlobalStyles.spacingStates.iconSize, 
            height: GlobalStyles.spacingStates.iconSize
          ),
        ),
      ),
    );
  }
}
