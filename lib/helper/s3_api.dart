import 'dart:io';

import 'dart:typed_data';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:thecomein/helper/comein_api.dart';
import 'package:path_provider/path_provider.dart';

class S3API {
  static Future<String> doUploadS3(Uint8List list) async {
    // Uint8List list = Uint8List.fromList(data);
    String s3_key = ComeInAPI.uuid.v1();
    File file = await writeToFile(list);
    String _key = await uploadFile(s3_key, file);
    print('write to file by key: ${s3_key}');
    return _key;
  }

  static Future<File> writeToFile(Uint8List data) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String uuid = ComeInAPI.uuid.v1();
    String tempFilename = '/${uuid}.tmp';
    var filePath = tempPath + tempFilename;
    print('file-path: $filePath}');
    return File(filePath).writeAsBytes(data);
  }

  static Future<String> uploadFile(String filename, File file) async {
    try {
      final s3_options =
          S3UploadFileOptions(accessLevel: StorageAccessLevel.guest);
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: file,
          key: filename,
          options: s3_options,
          onProgress: (progress) {
            print("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      print('Successfully uploaded file: ${result.key}');
      return result.key;
    } on StorageException catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }
}
