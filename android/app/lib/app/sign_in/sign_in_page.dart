import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/social_log_in_button.dart';
import '../../viewmodel/user_view_model.dart';
import 'email_login_register.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutlow'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade200,
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Oturum Açın',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  )),
              SizedBox(
                height: 8,
              ),
              SocialLoginButton(
                textColor: Colors.black87,
                butonIcon: Image.asset("images/google-logo.png"),
                butonText: 'Google ile Oturum Açın',
                onPressed: () => _googleIleGirirs(context),
                butonColor: Colors.white,
              ),
              SocialLoginButton(
                butonIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                  size: 32,
                ),
                butonText: 'Email ile Oturum Açın',
                onPressed: () => _emailRegisterLogin(context),
              ),
            ],
          ),
        ));
  }

  void _googleIleGirirs(BuildContext context) async {
    await Firebase.initializeApp();
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    await _viewModel.signInWighGoogle();
  }

  void _emailRegisterLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailRegisterLogin(),
      ),
    );
  }
}
