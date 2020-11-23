import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/navigation/app_config.dart';
import 'package:new_navigation/screens/todos_screen.dart';

class TodoDetailsScreen extends StatelessWidget {
  final Todo todo;

  static List<Todo> todos = <Todo>[
    Todo(name: "Sport", id: 1),
    Todo(name: "Meditate", id: 2),
    Todo(name: "Cook pelmenis", id: 3),
  ];

  TodoDetailsScreen({Key key, @required this.todo}) : super(key: key);

  AppConfig getConfig() {
    return AppConfig(
        uri: Uri(path: "/todo/${todo.id.toString()}"),
        widgetBelow: TodosScreen.getConfig(),
        selectedTodo: todo);
  }

  @override
  Widget build(BuildContext context) {
    print("[Build] Building TodoDetailsScreen ${todo.id.toString()}");
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              todo.name ??
                  todos.where((todo2) => todo2.id == todo.id).first.name,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
