import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? email;
  String? userName;
  String? profilURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;
  String? userID;

  MyUser({required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'UserID': userID,
      'email': email,
      'userName': userName ??
          email!.substring(0, email!.indexOf('@')) + randomSayiUret(),
      'profilURL': profilURL ?? 'https://images.app.goo.gl/2vd4Vd3Pka1osGeg9',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map) {
    userID = map['UserID'];
    email = map['email'];
    userName = map['userName'];
    profilURL = map['profilURL'];
    createdAt = (map['createdAt'] as Timestamp).toDate();
    updatedAt = (map['updatedAt'] as Timestamp).toDate();
    level = map['level'];
  }
  MyUser.idveResim({required this.userID, required this.profilURL});

  @override
  String toString() {
    return 'MyUser{email: $email, userName: $userName, profilURL: $profilURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level, userID: $userID}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
