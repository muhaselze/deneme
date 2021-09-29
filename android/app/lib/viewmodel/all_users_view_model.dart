import 'package:flutter/material.dart';

import '../locator.dart';
import '../model/my_user_model.dart';
import '../repository/user_repository.dart';

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

    getUser();
  }

  getUser() async {
    var yeniListe = await _userRepository.getUser();

    yeniListe
        .forEach((element) => print("getirilen username:" + element.userName!));
    _tumKullanicilar!.addAll(yeniListe);
    state = AllUserViewState.LOADED;
  }

  Future<void> refresh() async {
    getUser();
  }
}
