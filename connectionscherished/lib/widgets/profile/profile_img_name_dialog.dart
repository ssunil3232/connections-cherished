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

// ignore: must_be_immutable
class ProfileImgNameDialog extends StatefulWidget {
  ProfileImgNameDialog(
      {super.key,
      required this.name,
      required this.img,
      required this.onChanged});

  String name;
  String img;
  final Function(Map<String, String>) onChanged;
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
      setState(() {
        _imageFile = File(pickedFile.path);
        selectedAvatar = pickedFile.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _nameController.addListener(_updateState);
    selectedAvatar = widget.img;
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
            SizedBox(height: GlobalStyles.spacingStates.spacing20),
            Center(
              child: _imageFile != null
              ? Material(
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(side: BorderSide(color: GlobalStyles.defaultBorder, width: 0.5)),
                child: Image.file(
                  _imageFile!,
                  height: 136,
                  width: 136,
                  fit: BoxFit.cover,
                )
              )
              : CachedImageWidget(
                height: 136, 
                width: 136, 
                imageUrlProvided: selectedAvatar
              ),
            ),
            SizedBox(height: GlobalStyles.spacingStates.spacing16),
            Text(
              'Avatar options',
              textAlign: TextAlign.start,
              style: GlobalStyles.textStyles.textBody.copyWith(color: GlobalStyles.textSubtle),
            ),
            SizedBox(height: GlobalStyles.spacingStates.spacing8),
            _buildAvatarSection(),
            SizedBox(height: GlobalStyles.spacingStates.spacing16),
            CustomButtonWidget.secondary(
              text: 'Save',
              onPressed: _allValid ? () {
                if(_allValid){
                  widget.onChanged({'name': _nameController.text, 'img': selectedAvatar});
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
    return SizedBox(
      height: 80,
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
                padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing4),
                child: CachedImageWidget(
                  height: 60, 
                  width: 60, 
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
        padding: EdgeInsets.symmetric(horizontal: GlobalStyles.spacingStates.spacing4),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: GlobalStyles.defaultTextBg,
          child: SvgPicture.asset(
            icon, 
            width: 24, 
            height: 24
          ),
        ),
      ),
    );
  }
}
