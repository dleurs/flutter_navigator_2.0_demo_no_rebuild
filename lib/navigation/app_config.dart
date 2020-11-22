import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppConfig extends Equatable {
  final List<String> url;

  AppConfig({@required this.url});

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
  List<Object> get props => [url];
}
