import 'dart:io';
import 'package:connectionscherished/styles/styles.dart';
import 'package:connectionscherished/widgets/cached_image_widget.dart';
import 'package:connectionscherished/widgets/custom_button_widget.dart';
import 'package:connectionscherished/widgets/form-fields/input_field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileUpdate extends StatefulWidget {
  ProfileUpdate(
      {super.key,
      required this.name,
      required this.img,
      required this.onChanged});

  String name;
  String img;
  final Function(Map<String, String>) onChanged;
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  bool _allValid = true;
  bool _showNameError = false;
  final RegExp nameRegex = RegExp(r"^[a-zA-Z0-9_\xC0-\uFFFF]+([ \-']{0,1}[a-zA-Z0-9_\xC0-\uFFFF]+){0,2}[.]{0,1}$");
  final TextEditingController _nameController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _nameController.addListener(_updateState);
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
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(GlobalStyles.spacingStates.spacing16),
      backgroundColor: GlobalStyles.globalBgDefault,
      shape: RoundedRectangleBorder(
          // smoothness: 0.6,
          borderRadius: BorderRadius.circular(20.0),
        ),
      child: Container(
        padding: EdgeInsets.all(GlobalStyles.spacingStates.spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                InputFieldWidget(
                  labelText: 'Name',
                  controller: _nameController,
                ),
                SizedBox(height: GlobalStyles.spacingStates.spacing16),
                _imageFile != null
                ? Image.file(
                    _imageFile!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : CachedImageWidget(
                    height: 100, 
                    width: 100, 
                    imageUrlProvided: widget.img
                  ),
                SizedBox(height: GlobalStyles.spacingStates.spacing16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40), 
                  child: CustomButtonWidget.secondary(
                    height: 50,
                    icon: Icons.camera_alt_rounded,
                    onPressed: () => _pickImage(ImageSource.gallery),
                    text: 'Update Picture',
                  ),
                ),
                SizedBox(height: GlobalStyles.spacingStates.spacing24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButtonWidget.tertiary(text: 'Save', onPressed: _allValid ? () {
                      if(_allValid){
                        widget.onChanged({'name': _nameController.text, 'img': widget.img});
                        Navigator.of(context).pop();
                      }
                    }: null),
                    SizedBox(height: GlobalStyles.spacingStates.spacing16),
                    CustomButtonWidget.tertiaryAlert(text: 'Cancel', onPressed: () {
                        Navigator.of(context).pop();
                    }),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
