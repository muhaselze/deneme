import 'package:deneme/model/my_user_model.dart';
import 'package:deneme/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

enum AllUserViewState { IDLE, LOADED, BUSY }

class AllUserViewModel with ChangeNotifier {
  UserRepository _userRepository = locator<UserRepository>();

  AllUserViewState _state = AllUserViewState.IDLE;
  List<MyUser>? _tumKullanicilar;

  List<MyUser>? get kullanicilarListesi => _tumKullanicilar;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
  }

  Future<List<MyUser>?> getUser() async {
    var liste = await _userRepository.getUser();

    liste
        .forEach((element) => print("getirilen username:" + element.userName!));
    _tumKullanicilar!.addAll(liste);
    return _tumKullanicilar;
  }
}
