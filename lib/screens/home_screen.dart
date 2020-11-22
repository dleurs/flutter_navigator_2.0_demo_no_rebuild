import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/navigation/router_delegate.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen();

  static AppConfig getConfig() {
    return AppConfig(url: <String>[]);
  }

  @override
  Widget build(BuildContext context) {
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
                (Router.of(context).routerDelegate as MyRouterDelegate)
                    .toTodosScreen();
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
