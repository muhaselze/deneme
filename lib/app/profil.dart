import 'dart:io';

import 'package:deneme/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:deneme/common_widgets/social_log_in_button.dart';
import 'package:deneme/viewmodel/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController? _controllerUserName;
  File? _profilFoto;

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ViewModel userModel = Provider.of<ViewModel>(context, listen: false);
    _controllerUserName!.text = userModel.myUser!.userName!;

    print('profildeki user bilgileri :' + userModel.myUser.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil ve bilgi değiştirme ekranı'),
        actions: [
          TextButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Text(
              'Çıkış',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text('Kameradan Çek'),
                                  onTap: () {
                                    _kameradanFotoCek();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text('Galeriden Seç'),
                                  onTap: () {
                                    _galeridenResimSec();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundImage: _profilFoto == null
                        ? NetworkImage(userModel.myUser!.profilURL!)
                        : FileImage(_profilFoto!) as ImageProvider,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  initialValue: userModel.myUser!.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Emailiniz',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı İsminiz',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SocialLoginButton(
                    butonText: 'Değişiklikleri kaydet',
                    butonIcon: Icon(Icons.save),
                    onPressed: () {
                      _userNameGuncelle(context);
                      profilFotoGuncelle(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    bool sonuc = await _viewModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final _sonuc = await PlatformDuyarliAlertDialog(
      icerik: 'Emin misiniz?',
      baslik: 'Çıkış yapmak'
          ' istediğinizden emin misiniz?',
      anaButonYazisi: 'Tamam',
      iptalButonYazisi: 'Vazgeç',
    ).goster(context);
    if (_sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<ViewModel>(context, listen: false);
    if (_userModel.myUser!.userName != _controllerUserName!.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.myUser!.userID, _controllerUserName!.text);
      if (updateResult) {
        PlatformDuyarliAlertDialog(
          baslik: 'Başarılı',
          icerik: 'Yapılan değişiklik başarılı bir şekilde kaydedildi',
          anaButonYazisi: 'Tamam',
        ).goster(context);
      } else {
        _controllerUserName!.text = _userModel.myUser!.userName!;
        PlatformDuyarliAlertDialog(
          baslik: 'Hata',
          icerik: 'Herhangi bir '
              'değişiklik yapılamadı, zaten kullanımda farklı bir user name '
              'deneyiniz',
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _kameradanFotoCek() async {
    var _yeniResim = File(await ImagePicker()
        .pickImage(source: ImageSource.camera)
        .then((pickedFile) => pickedFile!.path));

    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim = File(await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((pickedFile) => pickedFile!.path));

    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  void profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<ViewModel>(context, listen: false);
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.myUser!.userID!, "profil_foto", _profilFoto!);
      print('indidirme linki :' + url);
      if (url != null) {
        PlatformDuyarliAlertDialog(
          baslik: 'Başarılı',
          icerik: 'Profil fotoğrafınız Güncellendi',
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }
}
