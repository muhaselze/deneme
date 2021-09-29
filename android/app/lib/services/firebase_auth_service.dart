import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/my_user_model.dart';
import 'auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyUser? _userFromFirebase(User user) {
    //firebase den gelen user ı benim
    // modelimdeki usera çeviren metod
    if (user == null) {
      return null;
    } else {
      return MyUser(userID: user.uid, email: user.email!);
    }
  }

  @override
  Future<MyUser?> currentUser() async {
    try {
      User? user = await _firebaseAuth.currentUser;
      return _userFromFirebase(user!);
    } catch (e) {
      debugPrint('hata çıktı' + e.toString());
      return null;
    }
  }

// @override
// Future<MyUser?> signInAnonymously() async {
//   try {
//     UserCredential sonuc = await _firebaseAuth.signInAnonymously();
//     return _userFromFirebase(sonuc.user!);
//   } catch (e) {
//     print("hata signInAnonymously" + e.toString());
//     return null;
//   }
// }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("hata signOut" + e.toString());
      return false;
    }
  }

  @override
  Future<MyUser?> signInWighGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = sonuc.user;
        return _userFromFirebase(_user!);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(sonuc.user!);
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(sonuc.user!);
  }

  @override
  Future<MyUser?> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }
}
