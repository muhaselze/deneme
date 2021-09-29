import 'package:cloud_firestore/cloud_firestore.dart';


import '../model/my_user_model.dart';
import 'database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser myUser) async {
    await _firestore.collection('users').doc(myUser.userID).set(myUser.toMap());
    DocumentSnapshot _okunanUser = await FirebaseFirestore.instance
        .doc('users/${myUser.userID}')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
      return documentSnapshot;
    });

    Map _okunanUserBilgileriMap = (_okunanUser.data()) as Map<String, dynamic>;
    MyUser? _okunanUserBilgileriNesne =
        MyUser.fromMap(_okunanUserBilgileriMap as Map<String, dynamic>);
    print('okunanUserBilgileri :' + _okunanUserBilgileriNesne.toString());

    return true;
  }

  @override
  Future<MyUser> readUser(String? userID) async {
    DocumentSnapshot _okunanUser = await FirebaseFirestore.instance
        .doc('users/$userID')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
      return documentSnapshot;
    });
    Map<String, dynamic> _okunanUserBilgileriMap =
        (_okunanUser.data()) as Map<String, dynamic>;

    MyUser? _okunanMyUserNesnesi = MyUser.fromMap(_okunanUserBilgileriMap);
    print('okunanusernesnesi :' + _okunanMyUserNesnesi.toString());
    return _okunanMyUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String? userID, String yeniUserName) async {
    var users = await _firestore
        .collection('users')
        .where('userName', isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection('users')
          .doc(userID)
          .update({'userName': yeniUserName});
      return true;
    }
  }

  Future<bool> updateProfilFoto(String userID, String profilFotoUrl) async {
    await _firestore
        .collection('users')
        .doc(userID)
        .update({'profilURL': profilFotoUrl});
    return true;
  }

  
  

  

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firestore.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });
    var okunanMap = await _firestore.collection("server").doc(userID).get();
    Timestamp okunanTarih = okunanMap["saat"];

    return okunanTarih.toDate();
  }

  @override
  Future<List<MyUser>> getUser() async {
    QuerySnapshot _querySnapshot;
    List<MyUser> _tumKullanicilar = [];
    // ignore: unnecessary_null_comparison
    
      print("ilk defa kullanıcılar getiriliyor");
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          
          .get();
     
    for (var snap in _querySnapshot.docs) {
      MyUser tekUser = MyUser.fromMap(snap.data() as Map<String, dynamic>);
      _tumKullanicilar.add(tekUser);
      print("getirilen user name :" + tekUser.userName.toString());
    }
    return _tumKullanicilar;
  }

  
}
