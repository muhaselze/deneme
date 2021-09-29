import 'dart:io';

import 'package:deneme/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:deneme/common_widgets/social_log_in_button.dart';
import 'package:deneme/model/my_user_model.dart';
import 'package:deneme/viewmodel/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class KullaniciDetayPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  KullaniciDetayPage(this.oankiUser);

  var oankiUser;
  @override
  _KullaniciDetayPageState createState() => _KullaniciDetayPageState();
}

class _KullaniciDetayPageState extends State<KullaniciDetayPage> {
  File? _profilFoto;

  @override
  Widget build(BuildContext context) {
    ViewModel userModel = Provider.of<ViewModel>(context, listen: false);

    print('profildeki user bilgileri :' + userModel.myUser.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Detay'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: _profilFoto == null
                      ? NetworkImage(widget.oankiUser.profilURL!)
                      : FileImage(_profilFoto!) as ImageProvider,
                  backgroundColor: Colors.white,
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(widget.oankiUser.userName!),
                  subtitle: Text(widget.oankiUser.email!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
