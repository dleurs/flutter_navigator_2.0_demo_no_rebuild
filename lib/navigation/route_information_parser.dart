import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/home_screen.dart';
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
      return RouteInformation(location: "/unknown");
    }
    if (state == HomeScreen.getConfig()) {
      return RouteInformation(location: "/");
    }
    if (state == TodosScreen.getConfig()) {
      return RouteInformation(location: "/todo");
    }
    // if(state == TodoDetailsScreen(todos:null).getConfig())
    if (state.uri.pathSegments.length == 2 &&
        state.uri.pathSegments[0] ==
            TodosScreen.getConfig().uri.pathSegments[0]) {
      String id = state.selectedTodo.id.toString();
      return RouteInformation(location: "/todo/$id");
    }
    return null;
  }
}
