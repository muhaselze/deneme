import 'dart:io';

import 'package:deneme/model/my_user_model.dart';
import 'package:deneme/services/auth_base.dart';
import 'package:deneme/services/fake_auth_service.dart';
import 'package:deneme/services/firebase_auth_service.dart';
import 'package:deneme/services/firebase_storage_sevice.dart';
import 'package:deneme/services/firestore_db_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../locator.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FireBaseStorageService _fireBaseStorageService =
      locator<FireBaseStorageService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  AppMode appMode = AppMode.RELEASE;
  List<MyUser> tumKullaniciListesi = [];
 
  @override
  Future<MyUser?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      MyUser? _myUser = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_myUser!.userID);
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<MyUser?> signInWighGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWighGoogle();
    } else {
      MyUser? _myUser = await _firebaseAuthService.signInWighGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_myUser!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_myUser.userID);
      } else
        return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, password);
    } else {
      MyUser? _myUser = await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);

      return _firestoreDBService.readUser(_myUser!.userID);
    }
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password);
    } else {
      MyUser? _myUser = await _firebaseAuthService
          .createUserWithEmailAndPassword(email, password);
      bool _sonuc = await _firestoreDBService.saveUser(_myUser!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_myUser.userID);
      } else
        return null;
    }
  }

  Future<bool> updateUserName(String? userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID!, yeniUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return await "dosya_indirme_linki";
    } else {
      var profilFotoUrl = await _fireBaseStorageService.uploadFile(
          userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoUrl);

      return profilFotoUrl;
    }
  }

 

  Future<List<MyUser>> getUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<MyUser> _userList = await _firestoreDBService.getUser();
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    }
  }
}
