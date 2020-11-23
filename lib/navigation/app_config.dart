import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';
import 'package:new_navigation/screens/home_screen.dart';
import 'package:new_navigation/screens/todo_details_screen.dart';
import 'package:new_navigation/screens/todos_screen.dart';
import 'package:new_navigation/screens/unknown_screen.dart';

class AppConfig extends Equatable {
  final Uri uri;
  final AppConfig widgetBelow;
  final Todo selectedTodo;

  AppConfig(
      {@required this.uri, @required this.widgetBelow, this.selectedTodo});

  @override
  String toString() {
    String str = "currentState{ ";
    if (this == null) {
      return str + "null }";
    }
    if (uri == null) {
      return str + "isUnknown }";
    } else {
      str += "url: " + this.uri.toString();
    }
    str += " }";
    return str;
  }

  @override
  List<Object> get props => [uri, selectedTodo];
  // widgetBelow should not be inside props
}

AppConfig parseRoute(Uri uri) {
  // Handle '/'
  if (uri.pathSegments.length == 0) {
    return HomeScreen.getConfig();
  }
  // Handle '/todo'
  if (uri.pathSegments.length == 1) {
    if (uri.pathSegments[0] == TodosScreen.getConfig().uri.pathSegments[0]) {
      return TodosScreen.getConfig();
    }
  }

  // Handle '/todo/:id'
  if (uri.pathSegments.length == 2) {
    if (uri.pathSegments[0] == TodosScreen.getConfig().uri.pathSegments[0]) {
      int todoId = int.tryParse(uri.pathSegments[1]);
      if (todoId != null) {
        return TodoDetailsScreen(
          todo: Todo(id: todoId),
        ).getConfig();
      }
    }
  }
  // Handle unknown routes
  return UnknownScreen.getConfig();
}
