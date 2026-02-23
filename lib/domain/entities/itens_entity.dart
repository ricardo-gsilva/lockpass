import 'package:equatable/equatable.dart';
import 'package:lockpass/core/extensions/string_validators.dart';

class ItensEntity extends Equatable{
  final String userId;
  final int? id;
  final String group;
  final String service;
  final String? site;
  final String email;
  final String login;
  final String password;
  final bool isDeleted;
  final DateTime? deletedAt;


  const ItensEntity({
    required this.userId,
    this.id,
    required this.group,
    required this.service,
    this.site,
    required this.email,
    required this.login,
    required this.password,
    this.isDeleted = false,
    this.deletedAt,
  });

  const ItensEntity.empty()
      : userId = '',
        id = 0,
        group = '',
        service = '',
        site = '',
        email = '',
        login = '',
        password = '',
        isDeleted = false,
        deletedAt = null;

    bool isValid() {
    return service.isNotNullOrBlank &&
        login.isNotNullOrBlank &&
        password.isNotNullOrBlank;
  }

  bool isDifferentFrom(ItensEntity other) {
    return group != other.group ||
        service != other.service ||
        site != other.site ||
        email != other.email ||
        login != other.login ||
        password != other.password ||
        isDeleted != other.isDeleted;
  }  

  ItensEntity copyWith({
    String? userId,
    int? id,
    String? group,
    String? service,
    String? site,
    String? email,
    String? login,
    String? password,
    bool? isDeleted,
    DateTime? deletedAt,
  }) {
    return ItensEntity(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      group: group ?? this.group,
      service: service ?? this.service,
      site: site ?? this.site,
      email: email ?? this.email,
      login: login ?? this.login,
      password: password ?? this.password,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    id,
    group,
    service,
    site,
    email,
    login,
    password,
    isDeleted,
    deletedAt,
  ];
}
