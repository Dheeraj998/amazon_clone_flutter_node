import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    // var files = await FilePicker.platform
    //     .pickFiles(type: FileType.image, allowMultiple: true);
    // if (files != null && files.files.isNotEmpty) {
    //   for (int i = 0; i < files.files.length; i++) {
    //     images.add(File(files.files[i].path!));
    //   }
    // }
    if (result != null) {
      images = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}
