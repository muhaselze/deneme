import 'package:deneme/app/sign_in/kullanici_detay.dart';
import 'package:deneme/model/my_user_model.dart';
import 'package:deneme/viewmodel/all_users_view_model.dart';
import 'package:deneme/viewmodel/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class KullanicilarPage extends StatefulWidget {
  const KullanicilarPage({Key? key}) : super(key: key);

  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  Widget build(BuildContext context) {
    final _tumKullanicilar = Provider.of<AllUserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
      ),
      body: FutureBuilder<List<MyUser>?>(
        future: _tumKullanicilar.getUser(),
        builder: (context, kullanicilar) {
          if (!kullanicilar.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                
                  return _userListeElemaniOlustur(index);
                
              },
              itemCount: kullanicilar.data!.length,
            );
          }
        },
      ),
    );
  }

  Widget _kullaniciYokUI() {
    final _tumKullanicilarViewModel =
        Provider.of<AllUserViewModel>(context);
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height - 150,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.supervised_user_circle,
              color: Theme.of(context).primaryColor,
              size: 120,
            ),
            Text(
              "Henüz kullanıcı yok!",
              style: TextStyle(fontSize: 36),
            ),
          ],
        )),
      ),
    );
  }

  Widget _userListeElemaniOlustur(int index) {
    final _userModel = Provider.of<ViewModel>(context, listen: false);
    final _tumKullanicilarViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    var oankiUser = _tumKullanicilarViewModel.kullanicilarListesi![index];
    
    if (oankiUser.userID == _userModel.myUser!.userID) {
      return Container();
    }
    return GestureDetector(onTap: (){
 Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context)=>KullaniciDetayPage(oankiUser),
          ),
        );
    },
    
      child: Card(
        child: ListTile(
          title: Text(oankiUser.userName!),
          subtitle: Text(oankiUser.email!),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(oankiUser.profilURL!),
            backgroundColor: Colors.grey.withAlpha(40),
          ),
        ),
      ),
    );
  }
}

