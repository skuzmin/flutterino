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

    final textContent = 'Title:\n\n$title\n\nDescription:\n\n$description\n\nTags:\n\n$tags';

    try {
      if (_selectedFile != null) {
        await _selectedFile!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        if (_selectedDirectory.isEmpty) {
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = directory!;
        }
        final filePath = '$_selectedDirectory/$todayDate - $title - Metadata.txt';
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);
      }
      SnackbarCustom.showSnackbar(context, Icons.check_circle, 'File saved successfully');
    } catch (e) {
      SnackbarCustom.showSnackbar(context, Icons.error, 'File not saved');
    }
  }

  void loadFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File file = File(result.files.single.path!);
        _selectedFile = file;

        final fileContent = await file.readAsString();

        final lines = fileContent.split('\n\n');
        titleController.text = lines[1];
        descriptionController.text = lines[3];
        tagsController.text = lines[5];
        SnackbarCustom.showSnackbar(context, Icons.upload_file, 'File uploaded');
      } else {
        SnackbarCustom.showSnackbar(context, Icons.error_rounded, 'No file selected');
      }
    } catch (e) {
      SnackbarCustom.showSnackbar(context, Icons.error_rounded, 'No file selected');
    }
  }

  void newFile(context) {
    _selectedFile = null;
    titleController.clear();
    descriptionController.clear();
    tagsController.clear();
    SnackbarCustom.showSnackbar(context, Icons.file_upload, 'New file created');
  }

  void newDirectory(context) async {
    try {
      String? directory = await FilePicker.platform.getDirectoryPath();
      _selectedDirectory = directory!;
      _selectedFile = null;
      SnackbarCustom.showSnackbar(context, Icons.folder, 'New folder selected');
    } catch (e) {
      SnackbarCustom.showSnackbar(context, Icons.error_rounded, 'No folder selected');
    }
  }

  static String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(now);
    return formattedDate;
  }
}
