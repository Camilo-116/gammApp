import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Class that handles the access and uploading of files to Storage Bucket
class StorageService {
  /// Uploads a file to the Storage Bucket
  ///
  /// Receives a [String] fileName, name of the file to be uploaded (including its extension),
  /// a [String] path, the file location in the device's storage and
  /// a [String] type, the type of upload to be done (The storage folder varies).
  ///
  /// At the end of the upload, returns a [String] with the uploaded file's reference.
  Future<String> uploadFile(String fileName, String path, int type) async {
    String reference = '';
    File file = File(path);

    switch (type) {
      case 0:
        reference = 'games_icons/';
        break;
      case 1:
        reference = 'platforms_logos/';
        break;
      case 2:
        reference = 'user_media/';
        break;
      default:
        log('Improper type');
        break;
    }

    if (fileName.isNotEmpty && path.isNotEmpty) {
      try {
        log('upload Reference: ${reference + fileName}');
        await FirebaseStorage.instance.ref(reference + fileName).putFile(file);
        return reference + fileName;
      } catch (err) {
        log('Error uploading file: $err');
        return '';
      }
    } else {
      log('Empty fileName or path');
      return '';
    }
  }

  /// Downloads a file from the Storage Bucket
  /// Receives a [String] url, the file's reference in the Storage Bucket
  ///
  /// At the end of the download, returns a [String] with the file's location in the device's storage.
  /// If the download fails, returns a [String] with 'Not downloaded'.
  Future<String> downloadURL(String reference) async {
    log('download reference: $reference');
    String path = '';
    try {
      path = await FirebaseStorage.instance.ref(reference).getDownloadURL();
      return path;
    } catch (err) {
      print(err);
      return 'Not downloaded';
    }
  }

  /// Deletes a file from the Storage Bucket
  ///
  /// Receives a [String] url, the file's reference in the Storage Bucket
  /// Returns a [bool] indicating if the file was deleted or not.
  Future<bool> deleteFile(String reference) async {
    try {
      log('Delete reference: $reference');
      await FirebaseStorage.instance.ref(reference).delete();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
