import 'package:flutter/material.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/navigation/router_delegate.dart';

class FirstScreen extends StatelessWidget {
  static AppConfig appConfig = AppConfig(url: <String>[]);

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
                (Router.of(context).routerDelegate as MyRouterDelegate)
                    .toSecondScreen(null);
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
