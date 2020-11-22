import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/first_screen.dart';
import 'package:new_navigation/screens/second_screen.dart';
import 'package:new_navigation/screens/unknown_screen.dart';

class MyRouterDelegate extends RouterDelegate<AppConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppConfig> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppConfig currentConfig = FirstScreen.appConfig;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppConfig get currentConfiguration {
    return currentConfig;
  }

  List<Page<dynamic>> buildPage() {
    List<Page<dynamic>> pages = [];
    // is shown even when currentState == null
    pages.add(
      MaterialPage(
        key: UniqueKey(),
        child: FirstScreen(),
      ),
    );
    if (currentConfig == null || currentConfig.url == null) {
      pages.add(MaterialPage(key: UniqueKey(), child: UnknownScreen()));
      return pages;
    }
    if (currentConfig.url.length >= 1) {
      if (currentConfig.url[0] == SecondScreen.appConfig.url[0]) {
        pages.add(MaterialPage(key: UniqueKey(), child: SecondScreen()));
      }
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    print("MyRouterDelegate building...");
    print(this.currentConfig);
    return Navigator(
      key: navigatorKey,
      pages: buildPage(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        currentConfig = FirstScreen.appConfig;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppConfig newState) async {
    currentConfig = newState;
    return;
  }

  void toSecondScreen(void nothing) {
    currentConfig = SecondScreen.appConfig;
    notifyListeners();
  }
}
