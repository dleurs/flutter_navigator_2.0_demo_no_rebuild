import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/navigation/route_page_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();

  static AppConfig getConfig() {
    return AppConfig(uri: Uri(path: "/"), widgetBelow: null);
  }

  @override
  Widget build(BuildContext context) {
    print("[Build] Building HomeScreen");
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello World",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 50),
            RaisedButton(
              onPressed: () {
                RoutePageManager.of(context).openTodosScreen();
              },
              child: Text(
                "Todo lists",
                style: Theme.of(context).textTheme.headline5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
