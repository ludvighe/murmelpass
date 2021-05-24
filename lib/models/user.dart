import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  User({this.key, this.name, this.email});
  String key;
  String name;
  String email;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(key: json['key'], name: json['name'], email: json['email']);
  }

  String toJson() {
    return jsonEncode(<String, dynamic>{'name': name, 'email': email});
  }
}
