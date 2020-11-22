import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/navigation/route_page_manager.dart';
import 'package:new_navigation/screens/todos_screen.dart';
import 'package:new_navigation/screens/todo_details_screen.dart';
import 'package:provider/provider.dart';

class MyRouterDelegate extends RouterDelegate<AppConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppConfig> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppConfig currentConfig = TodosScreen.getConfig();

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppConfig get currentConfiguration {
    return currentConfig;
  }

  List<Todo> todos = <Todo>[
    Todo(name: "Sport", id: 1),
    Todo(name: "Meditate", id: 2),
    Todo(name: "Cook pelmenis", id: 3),
  ];

  /* List<Page<dynamic>> buildPage() {
    List<Page<dynamic>> pages = [];
    // is shown even when currentState == null
    pages.add(
      MaterialPage(
        key: ValueKey(HomeScreen.getConfig().hashCode),
        child: HomeScreen(),
      ),
    );
    if (currentConfig == null || currentConfig.url == null) {
      pages.add(MaterialPage(
          key: ValueKey(UnknownScreen.getConfig.hashCode),
          child: UnknownScreen()));
      return pages;
    }
    if (currentConfig.url.length >= 1) {
      if (currentConfig.url[0] == TodosScreen.getConfig().url[0]) {
        pages.add(MaterialPage(
            key: ValueKey(TodosScreen.getConfig().hashCode),
            child: TodosScreen(
              todos: todos,
            )));
        if (currentConfig.url.length >= 2) {
          pages.add(
            MaterialPage(
                key: ValueKey(
                    TodoDetailsScreen(todo: currentConfig.selectedTodo)
                        .getConfig()
                        .hashCode),
                child: TodoDetailsScreen(todo: currentConfig.selectedTodo)),
          );
        }
      }
    }
    return pages;
   }*/

  final RoutePageManager pageManager = RoutePageManager();

  @override
  Widget build(BuildContext context) {
    print("MyRouterDelegate building...");
    //print(this.currentConfig);

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

    /* Navigator(
      key: navigatorKey,
      pages: buildPage(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        currentConfig = AppConfig(
          url: currentConfig.url.sublist(0, currentConfig.url.length - 1),
        );
        notifyListeners();

        return true;
      },
    ); */
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

  void toTodoDetailsScreen({@required Todo todo}) {
    currentConfig = TodoDetailsScreen(todo: todo).getConfig();
    notifyListeners();
  }

  void toTodosScreen() {
    currentConfig = TodosScreen.getConfig();
    notifyListeners();
  }
}
