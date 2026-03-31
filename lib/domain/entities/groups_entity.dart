import 'package:equatable/equatable.dart';

class GroupsEntity extends Equatable {
  final String groupName;
  final bool visible;

  const GroupsEntity({
    required this.groupName,
    this.visible = false,
  });

  GroupsEntity copyWith({
    bool? visible,
  }) {
    return GroupsEntity(
      groupName: groupName,
      visible: visible ?? this.visible,
    );
  }

  @override
  List<Object?> get props => [groupName, visible];

  @override
  String toString() {
    return 'GroupsEntity(group: $groupName, visible: $visible)';
  }
}
