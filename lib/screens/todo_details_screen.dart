import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/navigation/app_config.dart';

class TodoDetailsScreen extends StatelessWidget {
  final Todo todo;

  TodoDetailsScreen({@required this.todo});

  AppConfig getConfig() {
    return AppConfig(
        uri: Uri(path: "/todo/${todo.id.toString()}"), selectedTodo: todo);
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
              todo.name,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
