import 'package:equatable/equatable.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';

class ItensEntity extends Equatable{
  final String userId;
  final int? id;
  final String group;
  final String service;
  final String? site;
  final String email;
  final String login;
  final String password;

  const ItensEntity({
    required this.userId,
    this.id,
    required this.group,
    required this.service,
    this.site,
    required this.email,
    required this.login,
    required this.password,
  });

  const ItensEntity.empty()
      : userId = '',
        id = 0,
        group = '',
        service = '',
        site = '',
        email = '',
        login = '',
        password = '';

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
        password != other.password;
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
  ];
}
