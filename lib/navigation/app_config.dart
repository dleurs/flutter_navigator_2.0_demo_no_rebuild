import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:new_navigation/models/todo.dart';

class AppConfig extends Equatable {
  final List<String> url;
  final List<Todo> todos;
  final Todo selectedTodo;

  AppConfig({@required this.url, this.todos, this.selectedTodo});

  @override
  String toString() {
    String str = "currentState{ ";
    if (this == null) {
      return str + "null }";
    }
    if (url == null) {
      return str + "isUnknown }";
    } else {
      str += "url: " + this.url.toString();
    }
    str += " }";
    return str;
  }

  @override
  List<Object> get props => [url, selectedTodo];
}
