import 'dart:io';
import 'package:core/utils/utils.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> pickAndRenameImage(XFile pickedFile, String feature) async {
  String? fileMimeType = getFileExtension(pickedFile.path);
  final File originalFile = File(pickedFile.path);
  final directory = await getApplicationDocumentsDirectory();
  final String newFileName = "${feature}_${DateTime.now().millisecondsSinceEpoch}${fileMimeType!}";
  final String newFilePath = path.join(directory.path, newFileName);
  final File renamedFile = await originalFile.copy(newFilePath);
  return renamedFile;
}