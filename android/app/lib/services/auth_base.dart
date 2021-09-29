import '../model/my_user_model.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();

  Future<MyUser?> signInAnonymously();

  Future<bool> signOut();
  Future<MyUser?> signInWighGoogle();

  Future<MyUser?> signInWithEmailAndPassword(String email, String password);
  Future<MyUser?> createUserWithEmailAndPassword(String email, String password);
}
