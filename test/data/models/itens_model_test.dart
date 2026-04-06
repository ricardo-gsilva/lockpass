import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/models/itens_model.dart';

void main() {
  group('ItensModel', () {
    test('toMap serializes fields', () {
      final deletedAt = DateTime.utc(2024, 01, 02, 03, 04, 05);
      final model = ItensModel(
        userId: 'u',
        id: 1,
        group: 'g',
        service: 's',
        site: 'site',
        email: 'e',
        login: 'l',
        password: 'p',
        isDeleted: true,
        deletedAt: deletedAt,
      );

      final map = model.toMap();
      expect(map['userId'], 'u');
      expect(map['id'], 1);
      expect(map['itemGroup'], 'g');
      expect(map['service'], 's');
      expect(map['site'], 'site');
      expect(map['email'], 'e');
      expect(map['login'], 'l');
      expect(map['password'], 'p');
      expect(map['is_deleted'], 1);
      expect(map['deleted_at'], deletedAt.toIso8601String());
    });

    test('fromMap parses nullables and deletedAt', () {
      final map = <String, dynamic>{
        'userId': 'u',
        'id': 10,
        'itemGroup': 'g',
        'service': 's',
        'site': null,
        'email': null,
        'login': 'l',
        'password': 'p',
        'is_deleted': 0,
        'deleted_at': '2024-01-02T03:04:05.000Z',
      };

      final model = ItensModel.fromMap(map);
      expect(model.userId, 'u');
      expect(model.id, 10);
      expect(model.group, 'g');
      expect(model.service, 's');
      expect(model.site, isNull);
      expect(model.email, isNull);
      expect(model.isDeleted, isFalse);
      expect(model.deletedAt, DateTime.parse('2024-01-02T03:04:05.000Z'));
    });

    test('toEntity preserves values', () {
      const model = ItensModel(
        userId: 'u',
        id: 2,
        group: 'g',
        service: 's',
        site: null,
        email: null,
        login: 'l',
        password: 'p',
        isDeleted: false,
      );

      final entity = model.toEntity();
      expect(entity.userId, 'u');
      expect(entity.id, 2);
      expect(entity.group, 'g');
      expect(entity.service, 's');
      expect(entity.site, isNull);
      expect(entity.email, isNull);
      expect(entity.login, 'l');
      expect(entity.password, 'p');
      expect(entity.isDeleted, isFalse);
    });
  });
}

