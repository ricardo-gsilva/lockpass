class GroupsEntity {
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
  String toString() {
    return 'GroupsEntity(group: $groupName, visible: $visible)';
  }
}