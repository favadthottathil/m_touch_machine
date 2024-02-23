import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<File?> pickImage() async {
  File? file;
  try {
    var res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (res != null && res.files.isNotEmpty) {
      file = File(res.files.single.path!);
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return file;
}

Future<String> downloadUrl({required String fileName, required File file}) async {
  try {
    final referece = FirebaseStorage.instance.ref().child("usersProfile/$fileName");

    final uploadTask = referece.putFile(file);

    await uploadTask;

    final dowloadLink = await referece.getDownloadURL();

    return dowloadLink;
  } catch (e) {
    throw (e.toString());
  }
}
