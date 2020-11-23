import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/navigation/route_page_manager.dart';
import 'package:new_navigation/screens/home_screen.dart';
import 'package:new_navigation/screens/todos_screen.dart';
import 'package:new_navigation/screens/todo_details_screen.dart';
import 'package:provider/provider.dart';

class MyRouterDelegate extends RouterDelegate<AppConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppConfig> {
  //AppConfig currentConfig = HomeScreen.getConfig();

  MyRouterDelegate() {
    // This part is important because we pass the notification
    // from RoutePageManager to RouterDelegate. This way our navigation
    // changes (e.g. pushes) will be reflected in the address bar
    pageManager.addListener(notifyListeners);
  }

  AppConfig get currentConfiguration {
    return pageManager.currentConfiguration;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => pageManager.navigatorKey;

  final RoutePageManager pageManager = RoutePageManager();

  @override
  Widget build(BuildContext context) {
    print("MyRouterDelegate building...");

    return ChangeNotifierProvider<RoutePageManager>.value(
      value: pageManager,
      child: Consumer<RoutePageManager>(
        builder: (context, pageManager, child) {
          return Navigator(
            key: navigatorKey,
            onPopPage: _onPopPage,
            pages: List.of(pageManager.pages),
          );
        },
      ),
    );
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    pageManager.didPop(route.settings);
    return true;
  }

  @override
  Future<void> setNewRoutePath(AppConfig newConf) async {
    await pageManager.setNewRoutePath(newConf);
    return;
  }
}
