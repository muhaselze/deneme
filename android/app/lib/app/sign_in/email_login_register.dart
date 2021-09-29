import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/platform_duyarli_alert_dialog.dart';
import '../../common_widgets/social_log_in_button.dart';
import '../../model/my_user_model.dart';
import '../../viewmodel/user_view_model.dart';
import '../hata_exception.dart';

enum FormType { Register, Login }

class EmailRegisterLogin extends StatefulWidget {
  const EmailRegisterLogin({Key? key}) : super(key: key);

  @override
  _EmailRegisterLoginState createState() => _EmailRegisterLoginState();
}

class _EmailRegisterLoginState extends State<EmailRegisterLogin> {
  final _formKey = GlobalKey<FormState>();
  late String _buttonText, _linkText;
  late String _email, _password;
  var _formType = FormType.Login;

  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.Login ? 'Login' : 'Register';
    _linkText = _formType == FormType.Login
        ? 'Have an account to register'
        : 'I have '
            'already an '
            'account. Login';
    final _viewModel = Provider.of<ViewModel>(context);

    if (_viewModel.myUser != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Register/Login'),
      ),
      body: _viewModel.state == ViewState.IDLE
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: 'm@m.com',
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _viewModel.emailHataMesaji != null
                              ? _viewModel.emailHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'Email',
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (inputEmail) {
                          _email = inputEmail!;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        initialValue: '123456',
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: _viewModel.passHataMesaji != null
                              ? _viewModel.passHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.lock_outlined),
                          hintText: 'Password',
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (inputPassword) {
                          _password = inputPassword!;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SocialLoginButton(
                        radius: 10,
                        butonColor: Theme.of(context).primaryColor,
                        butonText: _buttonText,
                        butonIcon: Icon(Icons.app_registration),
                        onPressed: () => _formSubmit(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () => _change(),
                        child: Text(_linkText),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  _formSubmit() async {
    _formKey.currentState!.save();
    print(_email + _password);
    final _viewModel = Provider.of<ViewModel>(context, listen: false);
    if (_formType == FormType.Login) {
      try {
        MyUser? _inputUser =
            await _viewModel.signInWithEmailAndPassword(_email, _password);
        if (_inputUser != null) {
          print('oturum açan user id :' + _inputUser.userID.toString());
        }
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
                baslik: 'Oturum açma hata',
                icerik: Hatalar.goster(e.code),
                anaButonYazisi: 'Tamam')
            .goster(context);
      }
    } else {
      try {
        MyUser? _createdUser =
            await _viewModel.createUserWithEmailAndPassword(_email, _password);
        if (_createdUser != null) {
          print('oluşturulan user id :' + _createdUser.userID.toString());
        }
      } on PlatformException catch (e) {
        return PlatformDuyarliAlertDialog(
                baslik: 'Email Kullanımda',
                icerik: Hatalar.goster(e.code),
                anaButonYazisi: 'Tamam')
            .goster(context);
      }
    }
  }

  _change() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }
}
