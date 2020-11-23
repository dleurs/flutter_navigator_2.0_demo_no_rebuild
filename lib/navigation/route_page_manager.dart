import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/home_screen.dart';
import 'package:new_navigation/screens/todo_details_screen.dart';
import 'package:new_navigation/screens/todos_screen.dart';
import 'package:new_navigation/screens/unknown_screen.dart';
import 'package:provider/provider.dart';

class RoutePageManager extends ChangeNotifier {
  /// it's important to provide new list for Navigator each time
  /// because it compares previous list with the next one on each [NavigatorState didUpdateWidget]
  List<Page> get pages => List.unmodifiable(_pages);

  final List<Page> _pages = [
    MaterialPage(
      child: HomeScreen(),
      key: ValueKey(HomeScreen.getConfig().hashCode),
      name: HomeScreen.getConfig().uri.path,
    ),
  ];

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void didPop(Page page) {
    _pages.remove(page);
    notifyListeners();
  }

  static RoutePageManager of(BuildContext context) {
    return Provider.of<RoutePageManager>(context, listen: false);
  }

  AppConfig get currentConfiguration {
    return parseRoute(Uri.parse(_pages.last.name));
  }

  static List<Todo> todos = <Todo>[
    Todo(name: "Sport", id: 1),
    Todo(name: "Meditate", id: 2),
    Todo(name: "Cook pelmenis", id: 3),
  ];

  Future<void> setNewRoutePath(AppConfig config) async {
    print("setNewRoutePath");

    print("pagesKeysRequired()");
    List<Key> widgetToBuild = pagesKeysRequired(appConfig: config);
    print(widgetToBuild.toString());

    print("Begin pagesKeys()");
    print(pagesKeys().toString());

    // First Page, Handle "/" HomeScreen
    if (widgetToBuild.length >= 1) {
      if (_pages.length <= 0 || _pages[0].key != widgetToBuild[0]) {
        if (!_pages.contains(widgetToBuild[0])) {
          _pages.insert(
            0,
            MaterialPage(
              child: HomeScreen(),
              key: ValueKey(HomeScreen.getConfig().hashCode),
              name: '/',
            ),
          );
        } else {
          List<Key> pageKeys = pagesKeys();
          Page thePage = _pages.removeAt(pageKeys.indexOf(widgetToBuild[0]));
          _pages.insert(0, thePage);
        }
      }
    }

    // Second Page, Handle "/todo" or "/unknown" TodosScreen or UnknownScreen
    if (widgetToBuild.length >= 2) {
      if (_pages.length <= 1 || _pages[1].key != widgetToBuild[1]) {
        if (_pages.contains(widgetToBuild[1])) {
          List<Key> pageKeys = pagesKeys();
          Page thePage = _pages.removeAt(pageKeys.indexOf(widgetToBuild[1]));
          _pages.insert(1, thePage);
        } else {
          if (widgetToBuild[1] == ValueKey(TodosScreen.getConfig().hashCode)) {
            _pages.insert(
              1,
              MaterialPage(
                  key: ValueKey(TodosScreen.getConfig().hashCode),
                  child: TodosScreen(),
                  name: TodosScreen.getConfig().uri.path),
            );
          } else if (widgetToBuild[1] ==
              ValueKey(UnknownScreen.getConfig().hashCode)) {
            _pages.insert(
              1,
              MaterialPage(
                  key: ValueKey(UnknownScreen.getConfig.hashCode),
                  child: UnknownScreen(),
                  name: UnknownScreen.getConfig().uri.path),
            );
          }
        }
      }
    }

    // Third Page, Handle "/todo/:id" TodoDetailsScreen
    if (widgetToBuild.length >= 3) {
      if (_pages.length <= 2 || _pages[2].key != widgetToBuild[2]) {
        if (_pages.contains(widgetToBuild[2])) {
          List<Key> pageKeys = pagesKeys();
          Page thePage = _pages.removeAt(pageKeys.indexOf(widgetToBuild[2]));
          _pages.insert(2, thePage);
        } else {
          TodoDetailsScreen todoDetailsScreen = TodoDetailsScreen(
            todo: config.selectedTodo,
          );
          _pages.insert(
            2,
            MaterialPage(
              child: todoDetailsScreen,
              key: ValueKey(todoDetailsScreen.getConfig().hashCode),
              name: todoDetailsScreen.getConfig().uri.path,
            ),
          );
        }
      }
    }
    while (_pages.length > widgetToBuild.length) {
      _pages.removeLast();
    }

    print("End pagesKeys()");
    print(pagesKeys().toString());

    /*     // Second Page, Handle "/todo" TodosScreen
    if (widgetToBuild.length >= 3) {
      if (_pages[1].key != widgetToBuild[1]) {
        _pages.insert(
          1,
         MaterialPage(
              key: ValueKey(TodosScreen.getConfig().hashCode),
              child: TodosScreen(),
              name: TodosScreen.getConfig().uri.path),
        );
      }
    }

    // Handle "/todo" or "/unknown"
    else if (config.uri.pathSegments.length == 1) {
      if (config.uri.pathSegments[0] ==
          TodosScreen.getConfig().uri.pathSegments[0]) {
        //_pages.add(
          MaterialPage(
              key: ValueKey(TodosScreen.getConfig().hashCode),
              child: TodosScreen(),
              name: TodosScreen.getConfig().uri.path),
        );
      } else if (config.uri.pathSegments[0] ==
          UnknownScreen.getConfig().uri.pathSegments[0]) {
        //_pages.add(
        checkAndAddToPage(MaterialPage(
            key: ValueKey(UnknownScreen.getConfig.hashCode),
            child: UnknownScreen(),
            name: UnknownScreen.getConfig().uri.path));
      }
    }

    // Handle "/todo/:id"
    else if (config.uri.pathSegments.length == 2) {
      if (config.uri.pathSegments[0] ==
          TodosScreen.getConfig().uri.pathSegments[0]) {
        print("Key TodoDetailsScreen ${config.uri.pathSegments[1]}: " +
            ValueKey(TodoDetailsScreen(todo: config.selectedTodo)
                    .getConfig()
                    .hashCode)
                .toString());
        //_pages.add(
        checkAndAddToPage(
          MaterialPage(
              key: ValueKey(TodoDetailsScreen(todo: config.selectedTodo)
                  .getConfig()
                  .hashCode),
              child: TodoDetailsScreen(todo: config.selectedTodo),
              name: TodoDetailsScreen(todo: config.selectedTodo)
                  .getConfig()
                  .uri
                  .path),
        );
      }
    } */

    notifyListeners();
    return;
  }

/*   bool isKeyAlreadyUsed(Key keyToAdd) {
    for (final Page<dynamic> page in _pages) {
      final LocalKey key = page.key;
      if (key != null) {
        if (key == keyToAdd) {
          _pages.remove(_pages.length - 1);
          return true;
        }
      }
    }
    return false;
  } */

  List<Key> pagesKeysRequired({@required AppConfig appConfig}) {
    List<Key> keys = <Key>[ValueKey(appConfig.hashCode)];
    int againstInfiniteLoop = 0;
    AppConfig appConfigBelow = appConfig;
    while (appConfigBelow.widgetBelow != null && againstInfiniteLoop <= 5) {
      appConfigBelow = appConfigBelow.widgetBelow;
      keys.add(ValueKey(appConfigBelow.hashCode));
      againstInfiniteLoop++;
      if (againstInfiniteLoop == 5) {
        throw ("Against Infinite Loop pagesKeysRequired");
      }
    }
    return new List.from(keys.reversed);
  }

  List<Key> pagesKeys() {
    List<Key> keys = <Key>[];
    for (Page aPage in _pages) {
      keys.add(aPage.key);
    }
    return keys;
  }

/*   void checkAndAddToPage(Page pageToAdd) {
    if (!isKeyAlreadyUsed(pageToAdd.key)) {
      _pages.add(pageToAdd);
    }
  } */

  void openTodosScreen() {
    setNewRoutePath(TodosScreen.getConfig());
  }

  void openTodoDetailsScreen({@required Todo todo}) {
    setNewRoutePath(TodoDetailsScreen(todo: todo).getConfig());
  }
}
