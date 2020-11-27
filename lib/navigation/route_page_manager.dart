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

  final List<Page> _savedPages = []; // To keep poped pages

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void didPop(Page page) {
    if (indexPageInPages(page: page, pages: _savedPages) == null) {
      _savedPages.add(page);
    }
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
    List<Key> widgetToBuild = pagesKeysRequired(appConfig: config);

    print("----------Begin----------");
    print("widgetToBuild : " + widgetToBuild.toString());
    print("_pages : " + _pages.toString());
    print("_savedPages : " + _savedPages.toString());
    print("--------------------");

    // First Page, Handle "/" HomeScreen
    if (widgetToBuild.length >= 1) {
      if (_pages.length <= 0 || _pages[0].key != widgetToBuild[0]) {
        addOrGetPageToPages(
            indexInsert: 0,
            key: ValueKey(HomeScreen.getConfig().hashCode),
            path: HomeScreen.getConfig().uri.path,
            widget: HomeScreen());
      }
    }

    // Second Page, Handle "/todo" or "/unknown" TodosScreen or UnknownScreen
    if (widgetToBuild.length >= 2) {
      if (_pages.length <= 1 || _pages[1].key != widgetToBuild[1]) {
        Key unknownScreenKey = ValueKey(UnknownScreen.getConfig().hashCode);
        Key todosScreenKey = ValueKey(TodosScreen.getConfig().hashCode);
        if (widgetToBuild[1] == todosScreenKey) {
          addOrGetPageToPages(
              indexInsert: 1,
              key: todosScreenKey,
              path: TodosScreen.getConfig().uri.path,
              widget: TodosScreen());
        } else if (widgetToBuild[1] == unknownScreenKey) {
          addOrGetPageToPages(
              indexInsert: 1,
              key: unknownScreenKey,
              path: UnknownScreen.getConfig().uri.path,
              widget: UnknownScreen());
        }
      }
    }

    // Third Page, Handle "/todo/:id" TodoDetailsScreen
    if (widgetToBuild.length >= 3) {
      if (_pages.length <= 2 || _pages[2].key != widgetToBuild[2]) {
        TodoDetailsScreen todoDetailsScreen = TodoDetailsScreen(
          todo: config.selectedTodo,
        );
        addOrGetPageToPages(
            indexInsert: 2,
            key: ValueKey(todoDetailsScreen.getConfig().hashCode),
            path: todoDetailsScreen.getConfig().uri.path,
            widget: todoDetailsScreen);
      }
    }

    while (_pages.length > widgetToBuild.length) {
      Page lastPage = _pages.removeLast();
      if (indexPageInPages(page: lastPage, pages: _savedPages) == null) {
        _savedPages.add(lastPage);
      }
    }

    print("----------End----------");
    print("widgetToBuild : " + widgetToBuild.toString());
    print("_pages : " + _pages.toString());
    print("_savedPages : " + _savedPages.toString());
    print("--------------------");

    notifyListeners();
    return;
  }

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

  int indexPageInPages({Page page, Key pageKey, @required List<Page> pages}) {
    assert(
        (page == null && pageKey != null) || (page != null && pageKey == null));
    for (int i = 0; i < pages.length; i++) {
      Page pageOfPages = pages[i];
      if ((page?.key ?? pageKey) == pageOfPages.key) {
        return i;
      }
    }
    return null;
  }

  void addOrGetPageToPages(
      {@required int indexInsert,
      @required Key key,
      @required String path,
      @required Widget widget}) {
    int indexPageInSavedPages =
        indexPageInPages(pageKey: key, pages: _savedPages);
    if (indexPageInSavedPages != null) {
      _pages.insert(indexInsert, _savedPages[indexPageInSavedPages]);
      _savedPages.removeAt(indexPageInSavedPages);
    } else {
      _pages.insert(
        indexInsert,
        MaterialPage(key: key, child: widget, name: path),
      );
    }
  }

  void openTodosScreen() {
    setNewRoutePath(TodosScreen.getConfig());
  }

  void openTodoDetailsScreen({@required Todo todo}) {
    setNewRoutePath(TodoDetailsScreen(todo: todo).getConfig());
  }
}
