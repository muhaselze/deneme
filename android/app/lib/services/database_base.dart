
import '../model/my_user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser myUser);

  Future<MyUser> readUser(String userID);

  Future<bool> updateUserName(String userID, String yeniUserName);

  Future<bool> updateProfilFoto(String userID, String profilFotoUrl);

  Future<List<MyUser>> getUser();

  

 
  
  Future<DateTime> saatiGoster(String userID);
}
