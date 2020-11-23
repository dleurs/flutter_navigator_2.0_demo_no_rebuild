import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/home_screen.dart';
import 'package:new_navigation/screens/todo_details_screen.dart';
import 'package:new_navigation/screens/todos_screen.dart';
import 'package:new_navigation/screens/unknown_screen.dart';

class MyRouteInformationParser extends RouteInformationParser<AppConfig> {
  @override
  Future<AppConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    return parseRoute(uri);
  }

  @override
  RouteInformation restoreRouteInformation(AppConfig state) {
    if (state == UnknownScreen.getConfig()) {
      return RouteInformation(location: UnknownScreen.getConfig().uri.path);
    }
    if (state == HomeScreen.getConfig()) {
      return RouteInformation(location: HomeScreen.getConfig().uri.path);
    }
    if (state == TodosScreen.getConfig()) {
      return RouteInformation(location: TodosScreen.getConfig().uri.path);
    }
    // if(state == TodoDetailsScreen(todos:null).getConfig())
    if (state.uri.pathSegments.length == 2 &&
        state.uri.pathSegments[0] ==
            TodosScreen.getConfig().uri.pathSegments[0]) {
      return RouteInformation(
          location:
              TodoDetailsScreen(todo: state.selectedTodo).getConfig().uri.path);
    }
    return null;
  }
}
