import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';

class ItensModel extends Equatable{
  final String? userId;
  final int? id;
  final String type;
  final String service;
  final String? site;
  final String email;
  final String login;
  final String password;

  const ItensModel({
    this.userId,
    this.id,
    required this.type,
    required this.service,
    this.site,
    required this.email,
    required this.login,
    required this.password,
  });

  const ItensModel.empty()
      : userId = '',
        id = 0,
        type = '',
        service = '',
        site = '',
        email = '',
        login = '',
        password = '';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'type': type,
      'service': service,
      'site': site,
      'email': email,
      'login': login,
      'password': password,
    };
  }

  factory ItensModel.fromMap(Map<String, dynamic> map) {
    return ItensModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
      type: map['type'] as String? ?? '',
      service: map['service'] as String? ?? '',
      site: map['site'] != null ? map['site'] as String : null,
      email: map['email'] as String? ?? '',
      login: map['login'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  ItensModel copyWith({
    String? userId,
    int? id,
    String? type,
    String? service,
    String? site,
    String? email,
    String? login,
    String? password,
  }) {
    return ItensModel(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      type: type ?? this.type,
      service: service ?? this.service,
      site: site ?? this.site,
      email: email ?? this.email,
      login: login ?? this.login,
      password: password ?? this.password,
    );
  }

  bool isValid() {
    return service.isNotNullOrBlank &&
        login.isNotNullOrBlank &&
        password.isNotNullOrBlank;
  }

  bool isDifferentFrom(ItensModel other) {
    return type != other.type ||
        service != other.service ||
        site != other.site ||
        email != other.email ||
        login != other.login ||
        password != other.password;
  }

  String toJson() => json.encode(toMap());

  factory ItensModel.fromJson(String source) =>
      ItensModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItensModel(userId: $userId, id: $id, type: $type, service: $service, site: $site, email: $email, login: $login, password: $password)';
  }

  @override
  List<Object?> get props => [
    userId,
    id,
    type,
    service,
    site,
    email,
    login,
    password,
  ];
}
