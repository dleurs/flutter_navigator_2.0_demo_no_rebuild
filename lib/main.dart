import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyRouterDelegate _routerDelegate = MyRouterDelegate();
  MyRouteInformationParser _routeInformationParser = MyRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Flutter App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class MyRouteInformationParser extends RouteInformationParser<AppState> {
  @override
  Future<AppState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return AppState.firstPage();
    }

    // Handle '/second'
    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == 'second') return AppState.secondPage();
    }

    // Handle unknown routes
    return AppState.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppState state) {
    if (state.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (state.isFirstPage) {
      return RouteInformation(location: '/');
    }
    if (state.isSecondPage) {
      return RouteInformation(location: '/second');
    }
    return null;
  }
}

class MyRouterDelegate extends RouterDelegate<AppState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppState> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppState currentState = AppState.firstPage();

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppState get currentConfiguration {
    return currentState;
  }

  List<Page<dynamic>> buildPage() {
    List<Page<dynamic>> pages = [];
    // is shown even when currentState == null
    pages.add(
      MaterialPage(
        key: ValueKey('FirstPage'),
        child: FirstScreen(
          onTapped: _handleTapped,
        ),
      ),
    );
    if (currentState == null || currentState.isUnknown) {
      pages.add(
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen()));
    } else if (currentState.isSecondPage) {
      // Must be at the end in order to show NavBar back button when 404
      pages.add(
          MaterialPage(key: ValueKey('SecondPage'), child: SecondScreen()));
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    print("MyRouterDelegate building...");
    print(this.currentState);
    return Navigator(
      key: navigatorKey,
      pages: buildPage(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        currentState = AppState.firstPage();
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppState newState) async {
    currentState = newState;
    return;
  }

  void _handleTapped(void nothing) {
    currentState = AppState.secondPage();
    notifyListeners();
  }
}

class AppState {
  final bool showSecondPage;
  final bool unknown;

  AppState.firstPage()
      : showSecondPage = false,
        unknown = false;

  AppState.secondPage()
      : showSecondPage = true,
        unknown = false;

  AppState.unknown()
      : showSecondPage = false,
        unknown = true;

  bool get isFirstPage => (!isUnknown && showSecondPage == false);

  bool get isSecondPage => (!isUnknown && showSecondPage == true);

  bool get isUnknown => (unknown == true);

  @override
  String toString() {
    String str = "currentState{ ";
    if (this == null) {
      return str + "null }";
    }
    if (isUnknown) {
      str += "isUnknown";
    } else {
      if (isFirstPage) {
        str += "firstPage";
      } else {
        str += "secondPage";
      }
    }
    str += " }";
    return str;
  }
}

class FirstScreen extends StatelessWidget {
  final ValueChanged onTapped;

  FirstScreen({
    @required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "First screen",
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              onPressed: () {
                onTapped(null);
              },
              child: Text(
                "Show second page",
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "Second screen",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          "Page not found",
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
    );
  }
}
