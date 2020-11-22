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
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return HomeScreen.getConfig();
    }
    // Handle '/todo'
    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == TodosScreen.getConfig().url[0]) {
        return TodosScreen.getConfig();
      }
    }

    // Handle '/todo/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == TodosScreen.getConfig().url[0]) {
        int todoId = int.tryParse(uri.pathSegments[1]);
        if (todoId != null) {
          return TodosScreen.getConfig();
        }
      }
    }
    // Handle unknown routes
    return UnknownScreen.getConfig();
  }

  @override
  RouteInformation restoreRouteInformation(AppConfig state) {
    if (state.url == null) {
      return RouteInformation(location: "/unknown");
    }
    if (state.url.isEmpty) {
      return RouteInformation(location: "/");
    }
    String urlWithSlash = "";
    for (String urlSection in state.url) {
      urlWithSlash += "/" + urlSection;
    }
    return RouteInformation(location: urlWithSlash);
  }
}
