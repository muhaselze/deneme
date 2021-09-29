import 'package:deneme/app/kullanicilar.dart';
import 'package:deneme/app/my_custom_bottom_navi.dart';
import 'package:deneme/app/profil.dart';
import 'package:deneme/app/tab_items.dart';
import 'package:deneme/viewmodel/all_users_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/my_user_model.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.myUser}) : super(key: key);
  late final MyUser myUser;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (BuildContext context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
     
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: MyCostomBottomNavigation(
        onSelectedTab: (TabItem secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]!
                .currentState!
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }

          print("seçilen tab item :" + secilenTab.toString());
        },
        currentTab: _currentTab,
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
