import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Todo extends Equatable {
  final String name;
  final int id;

  Todo({this.name, @required this.id});

  @override
  List<Object> get props => [name];
}
