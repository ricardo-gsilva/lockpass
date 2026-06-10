import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/mappers/itens_mapper.dart';
import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';

void main() {
  group('ItensMapper', () {
    test('toEntity delegates to model.toEntity', () {
      const model = ItensModel(
        userId: 'u',
        id: 1,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final entity = ItensMapper.toEntity(model);
      expect(entity, isA<ItensEntity>());
      expect(entity.userId, 'u');
      expect(entity.id, 1);
    });

    test('toModel builds model from entity', () {
      const entity = ItensEntity(
        userId: 'u',
        id: 1,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final model = ItensMapper.toModel(entity);
      expect(model, isA<ItensModel>());
      expect(model.userId, 'u');
      expect(model.id, 1);
    });
  });
}

