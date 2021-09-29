import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/all_users_view_model.dart';

import '../viewmodel/user_view_model.dart';

class KullanicilarPage extends StatefulWidget {
  const KullanicilarPage({Key? key}) : super(key: key);

  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //minscrollExtent listenin en altına geldiğimizde oluşur.
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.BUSY) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.LOADED) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.kullanicilarListesi!.length == 1) {
                    return _kullaniciYokUI();
                  } else {
                    return _userListeElemaniOlustur(index);
                  }
                },
                itemCount: model.kullanicilarListesi!.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _kullaniciYokUI() {
    final _tumKullanicilarViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    return RefreshIndicator(
      onRefresh: _tumKullanicilarViewModel.refresh,
      child: SingleChildScrollView(
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
    return Card(
      child: ListTile(
        title: Text(oankiUser.userName!),
        subtitle: Text(oankiUser.email!),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(oankiUser.profilURL!),
          backgroundColor: Colors.grey.withAlpha(40),
        ),
      ),
    );
  }

  Widget _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  

 
}
