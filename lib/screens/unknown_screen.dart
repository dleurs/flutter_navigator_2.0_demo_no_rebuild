import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';

class UnknownScreen extends StatelessWidget {
  static AppConfig getConfig() {
    return AppConfig(uri: Uri(path: "/unknown"));
  }

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
