import 'dart:io';

import 'package:deneme/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class FireBaseStorageService implements StorageBase {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(userID)
        .child(fileType);
    await ref.putFile(profilFoto);
    var url = await ref.getDownloadURL();
    return url;
  }
}
