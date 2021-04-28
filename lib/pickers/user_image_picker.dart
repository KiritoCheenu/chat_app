import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _imagePicked;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _imagePicked = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _imagePicked != null ? FileImage(_imagePicked) : null,
        ),
        TextButton.icon(
            style: TextButton.styleFrom(
                textStyle: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add Image')),
      ],
    );
  }
}
