import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/user_view_model.dart';
import 'home_page.dart';
import 'sign_in/sign_in_page.dart';

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
