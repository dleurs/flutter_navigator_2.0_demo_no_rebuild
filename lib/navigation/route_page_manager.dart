import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/home_screen.dart';
import 'package:new_navigation/screens/unknown_screen.dart';

class RoutePageManager extends ChangeNotifier {
  /// it's important to provide new list for Navigator each time
  /// because it compares previous list with the next one on each [NavigatorState didUpdateWidget]
  List<Page> get pages => List.unmodifiable(_pages);

  final List<Page> _pages = [
    MaterialPage(
      child: HomeScreen(),
      key: ValueKey(HomeScreen.getConfig().hashCode),
    ),
  ];

  void didPop(Page page) {
    _pages.remove(page);
    notifyListeners();
  }

  Future<void> setNewRoutePath(AppConfig config) async {
    if (config == UnknownScreen.getConfig()) {
      // Handling 404
      _pages.add(
        MaterialPage(
          child: UnknownScreen(),
          key: UniqueKey(),
          name: '/404',
        ),
      );
    } else if (configuration.isDetailsPage) {
      // Handling details screens
      _pages.add(
        MaterialPage(
          child: DetailsScreen(id: configuration.id),
          key: UniqueKey(),
          name: '/details/${configuration.id}',
        ),
      );
    } else if (configuration.isHomePage) {
      // Restoring to MainScreen
      _pages.removeWhere(
        (element) => element.key != const Key('MainScreen'),
      );
    }
    notifyListeners();
    return;
  }
}
