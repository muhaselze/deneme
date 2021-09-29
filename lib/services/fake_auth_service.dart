import 'package:deneme/model/my_user_model.dart';
import 'package:deneme/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "1231213213131321313131";

  @override
  Future<MyUser?> currentUser() async {
    return await Future.value(MyUser(userID: userID, email: 'fake@fake.com'));
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 2),
        () => MyUser(userID: userID, email: 'fake@fake.com'));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<MyUser> signInWighGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => MyUser(
            userID: 'goog'
                'le_user_id_1321546'
                '',
            email: 'fake@fake.com'));
  }

  @override
  Future<MyUser?> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => MyUser(
            userID: 'face'
                'book_user_id_16654468'
                '',
            email: 'fake@fake.com'));
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => MyUser(
            userID: 'sign'
                'ed_user_id_65461656'
                '',
            email: 'fake@fake.com'));
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2),
        () => MyUser(
            userID: 'crea'
                'ted'
                'ed_user_id_65461656',
            email: 'fake@fake.com'));
  }
}
