import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:password_manager_r1/models/hash_length.dart';

class PasswordData {
  PasswordData(
      {this.id = '',
      @required this.title,
      @required this.salt,
      @required this.count,
      @required this.length,
      this.created,
      this.lastUsed});

  String id;
  String title, salt;
  int count;
  HashLength length;
  DateTime created, lastUsed;

  String lastUsedAsString() => lastUsed.toString().split('.')[0];
  String createdAsString() => created.toString().split('.')[0];

  factory PasswordData.fromJson(Map<String, dynamic> json) {
    return PasswordData(
        id: json['id'],
        title: json['title'],
        salt: json['salt'],
        count: json['count'],
        length: HashLength.fromInt(json['length']),
        created: DateTime.parse(json['created']),
        lastUsed: DateTime.parse(json['last_used']));
  }

  String toJson({bool noId = false}) {
    return jsonEncode(<String, dynamic>{
      if (!noId) 'id': id,
      'title': title,
      'salt': salt,
      'count': count,
      'length': length.toInt(),
      'created': created.toIso8601String(),
      'last_used': lastUsed.toIso8601String()
    });
  }
}
