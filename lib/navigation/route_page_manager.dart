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
    // Handle error
    if (config == null || config.uri == null) {
      _pages.add(MaterialPage(
          key: ValueKey(UnknownScreen.getConfig.hashCode),
          child: UnknownScreen(),
          name: UnknownScreen.getConfig().uri.path));
    }

    // Handle "/"
    else if (config.uri.pathSegments.length == 0) {
      print("Key HomeScreen: " + (HomeScreen.getConfig().hashCode).toString());
      _pages.removeWhere(
        (element) =>
            element
                .key != /* const */ ValueKey(HomeScreen.getConfig().hashCode),
      );
    }

    // Handle "/todo" or "/unknown"
    else if (config.uri.pathSegments.length == 1) {
      if (config.uri.pathSegments[0] ==
          TodosScreen.getConfig().uri.pathSegments[0]) {
        _pages.add(
          MaterialPage(
              key: ValueKey(TodosScreen.getConfig().hashCode),
              child: TodosScreen(
                todos: todos,
              ),
              name: TodosScreen.getConfig().uri.path),
        );
      } else if (config.uri.pathSegments[0] ==
          UnknownScreen.getConfig().uri.pathSegments[0]) {
        _pages.add(MaterialPage(
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
        _pages.add(
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
    }
    notifyListeners();
    return;
  }

  void openTodosScreen() {
    setNewRoutePath(TodosScreen.getConfig());
  }

  void openTodoDetailsScreen({@required Todo todo}) {
    setNewRoutePath(TodoDetailsScreen(todo: todo).getConfig());
  }
}
