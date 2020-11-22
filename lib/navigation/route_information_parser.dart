import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/first_screen.dart';
import 'package:new_navigation/screens/second_screen.dart';
import 'package:new_navigation/screens/unknown_screen.dart';

class MyRouteInformationParser extends RouteInformationParser<AppConfig> {
  @override
  Future<AppConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return FirstScreen.appConfig;
    }
    // Handle '/second'
    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments[0] == SecondScreen.appConfig.url[0])
        return SecondScreen.appConfig;
    }

    // Handle unknown routes
    return UnknownScreen.appConfig;
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
