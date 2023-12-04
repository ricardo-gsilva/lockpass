// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItensModel {
  int? id;
  String? type;
  String? service;
  String? site;
  String? email;
  String? login;
  String? password;
  
  ItensModel({
    this.id,
    this.type,
    this.service,
    this.site,
    this.email,
    this.login,
    this.password,
  });

  ItensModel.empty():
    id = 0,
    type = '',
    service = '',
    site = '',
    email = '',
    login = '',
    password = '';  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
      id: map['id'] != null ? map['id'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      service: map['service'] != null ? map['service'] as String : null,
      site: map['site'] != null ? map['site'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      login: map['login'] != null ? map['login'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItensModel.fromJson(String source) => ItensModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItensModel(id: $id, type: $type, service: $service, site: $site, email: $email, login: $login, password: $password)';
  }
}
