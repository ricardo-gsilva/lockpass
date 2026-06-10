import 'package:lockpass/domain/entities/itens_entity.dart';

class ItensModel extends ItensEntity {
  const ItensModel({
    required super.userId,
    super.id,
    required super.group,
    required super.service,
    super.site,
    super.email,
    required super.login,
    required super.password,
    super.isDeleted = false,
    super.deletedAt,
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
      'is_deleted': isDeleted ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  factory ItensModel.fromMap(Map<String, dynamic> map) {
    final deletedAtRaw = map['deleted_at'] as String?;
    return ItensModel(
      userId: (map['userId'] as String?) ?? '',
      id: map['id'] as int?,
      group: (map['itemGroup'] as String?) ?? '',
      service: (map['service'] as String?) ?? '',
      site: map['site'] as String?,
      email: map['email'] as String?,
      login: (map['login'] as String?) ?? '',
      password: (map['password'] as String?) ?? '',
      isDeleted: (map['is_deleted'] ?? 0) == 1,
      deletedAt: deletedAtRaw != null ? DateTime.tryParse(deletedAtRaw) : null,
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
      isDeleted: isDeleted,
      deletedAt: deletedAt,
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
      isDeleted: entity.isDeleted,
      deletedAt: entity.deletedAt,
    );
  }
}
