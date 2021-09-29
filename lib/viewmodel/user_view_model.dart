import 'dart:io';

import 'package:deneme/model/my_user_model.dart';
import 'package:deneme/repository/user_repository.dart';
import 'package:deneme/services/auth_base.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';

enum ViewState { IDLE, BUSY }

class ViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.IDLE;

  UserRepository _userRepository = locator<UserRepository>();

  MyUser? _myUser;

  MyUser? get myUser => _myUser;

  String? emailHataMesaji;
  String? passHataMesaji;

  ViewModel() {
    currentUser();
  }

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<MyUser?> currentUser() async {
    try {
      state = ViewState.BUSY;
      _myUser = (await _userRepository.currentUser());
      return _myUser;
    } catch (e) {
      print('view modeldeki current user da hata' + e.toString());
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      _state = ViewState.BUSY;
      bool sonuc = await _userRepository.signOut();
      _myUser = null;
      return sonuc;
    } catch (e) {
      return false;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<MyUser?> signInWighGoogle() async {
    try {
      state = ViewState.BUSY;
      _myUser = (await _userRepository.signInWighGoogle())!;
      return _myUser;
    } catch (e) {
      print('view modeldeki signInGoogle da hata' + e.toString());
      return null;
    } finally {
      state = ViewState.IDLE;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    if (_emailPassControl(email, password)) {
      try {
        state = ViewState.BUSY;
        _myUser = (await _userRepository.signInWithEmailAndPassword(
            email, password))!;

        return _myUser;
      } finally {
        state = ViewState.IDLE;
      }
    } else
      return null;
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (_emailPassControl(email, password)) {
      try {
        state = ViewState.BUSY;
        _myUser = (await _userRepository.createUserWithEmailAndPassword(
            email, password))!;

        return _myUser;
      } finally {
        state = ViewState.IDLE;
      }
    } else
      return null;
  }

  bool _emailPassControl(String email, String password) {
    var sonuc = true;

    if (password.length < 6) {
      passHataMesaji = 'must be at  least 6 characters';
      sonuc = false;
    } else
      passHataMesaji = null;

    if (!email.contains('@')) {
      emailHataMesaji = 'Invalid email account!';
      sonuc = false;
    } else
      emailHataMesaji = null;

    return sonuc;
  }

  Future<bool> updateUserName(String? userID, String yeniUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (sonuc) {
      myUser!.userName = yeniUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var indirmeLinki =
        await _userRepository.uploadFile(userID, fileType, profilFoto);
    return indirmeLinki;
  }

  
}
