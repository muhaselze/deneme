import 'package:deneme/app/home_page.dart';
import 'package:deneme/app/sign_in/sign_in_page.dart';
import 'package:deneme/viewmodel/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<ViewModel>(context);

    if (_viewModel.state == ViewState.IDLE) {
      if (_viewModel.myUser == null) {
        return SignInPage();
      } else {
        return HomePage(
          myUser: _viewModel.myUser!,
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
