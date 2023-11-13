import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterino/utils/snackbar_custom.dart';
import 'package:intl/intl.dart';

class FileService {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedFile;
  String _selectedDirectory = '';

  void saveContent(context) async {
    final title = titleController.text;
    final description = descriptionController.text;
    final tags = tagsController.text;

    final textContent =
        'Title:\n\n$title\n\nDescription:\n\n$description\n\nTags:\n\n$tags';

    try {
      if (_selectedFile != null) {
        await _selectedFile!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        if (_selectedDirectory.isEmpty) {
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = directory!;
        }
        final filePath =
            '$_selectedDirectory/$todayDate - $title - Metadata.txt';
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);
      }
      SnackbarCustom.showSnackbar(
          context, Icons.check_circle, 'File saved successfully');
    } catch (e) {
      SnackbarCustom.showSnackbar(context, Icons.error, 'File not saved');
    }
  }

  static String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    return formattedDate;
  }
}
