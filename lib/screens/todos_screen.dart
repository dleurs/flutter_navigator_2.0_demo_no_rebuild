import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/navigation/route_page_manager.dart';
import 'package:new_navigation/screens/home_screen.dart';

class TodosScreen extends StatelessWidget {
  static List<Todo> todos = <Todo>[
    Todo(name: "Sport", id: 1),
    Todo(name: "Meditate", id: 2),
    Todo(name: "Cook pelmenis", id: 3),
  ];

  static AppConfig getConfig() {
    return AppConfig(
        uri: Uri(path: "/todo"), widgetBelow: HomeScreen.getConfig());
  }

  @override
  Widget build(BuildContext context) {
    print("[Build] Building TodosScreen");
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            Todo todo = todos[index];
            return ListTile(
                title: Text(todo.name),
                subtitle: Text(todo.id.toString()),
                onTap: () {
                  RoutePageManager.of(context)
                      .openTodoDetailsScreen(todo: todo);
                });
          }),
    );
  }
}
