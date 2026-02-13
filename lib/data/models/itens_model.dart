import 'package:lockpass/domain/entities/itens_entity.dart';

class ItensModel extends ItensEntity {
  const ItensModel({
    required super.userId,
    super.id,
    required super.group,
    required super.service,
    super.site,
    required super.email,
    required super.login,
    required super.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'itemGroup': group,
      'service': service,
      'site': site,
      'email': email,
      'login': login,
      'password': password,
    };
  }

  factory ItensModel.fromMap(Map<String, dynamic> map) {
    return ItensModel(
      userId: map['userId'] ?? '',
      id: map['id'],
      group: map['itemGroup'] ?? '',
      service: map['service'] ?? '',
      site: map['site'],
      email: map['email'] ?? '',
      login: map['login'] ?? '',
      password: map['password'] ?? '',
    );
  }

  ItensEntity toEntity() {
    return ItensEntity(
      userId: userId,
      id: id,
      group: group,
      service: service,
      site: site,
      email: email,
      login: login,
      password: password,
    );
  }

  factory ItensModel.fromEntity(ItensEntity entity) {
    return ItensModel(
      userId: entity.userId,
      id: entity.id,
      group: entity.group,
      service: entity.service,
      site: entity.site,
      email: entity.email,
      login: entity.login,
      password: entity.password,
    );
  }
}