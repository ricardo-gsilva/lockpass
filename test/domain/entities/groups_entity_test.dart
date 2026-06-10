import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/domain/entities/groups_entity.dart';

void main() {
  group('GroupsEntity', () {
    test('default visible is false', () {
      const entity = GroupsEntity(groupName: 'A');
      expect(entity.visible, isFalse);
    });

    test('copyWith updates visible', () {
      const entity = GroupsEntity(groupName: 'A', visible: false);
      final next = entity.copyWith(visible: true);

      expect(next.groupName, 'A');
      expect(next.visible, isTrue);
    });

    test('supports value equality (Equatable)', () {
      expect(
        const GroupsEntity(groupName: 'A', visible: true),
        const GroupsEntity(groupName: 'A', visible: true),
      );
      expect(
        const GroupsEntity(groupName: 'A', visible: true),
        isNot(const GroupsEntity(groupName: 'A', visible: false)),
      );
    });
  });
}

