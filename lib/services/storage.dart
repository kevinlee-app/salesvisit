import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class StorageService {
  Future<StorageServiceResult> uploadImage({
    @required File imageToUpload,
    @required String title,
  }) async {
    var folderName = "/visits/image/";
    var imageFileName =
        title + DateTime.now().millisecondsSinceEpoch.toString();
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(folderName + imageFileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return StorageServiceResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }
    return null;
  }

  Future deleteImage(String imageFileName) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);
    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

class StorageServiceResult {
  final String imageUrl;
  final String imageFileName;

  bool get success {
    return imageUrl != null && imageUrl.isNotEmpty;
  }  
  StorageServiceResult({this.imageUrl, this.imageFileName});
}
