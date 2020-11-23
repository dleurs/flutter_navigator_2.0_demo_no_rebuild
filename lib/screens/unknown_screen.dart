import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/home_screen.dart';

class UnknownScreen extends StatelessWidget {
  static AppConfig getConfig() {
    return AppConfig(
        uri: Uri(path: "/unknown"), widgetBelow: HomeScreen.getConfig());
  }

  @override
  Widget build(BuildContext context) {
    print("Building UnknownScreen");
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
