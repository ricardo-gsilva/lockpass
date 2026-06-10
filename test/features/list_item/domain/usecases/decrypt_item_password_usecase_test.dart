import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/domain/usecases/decrypt_item_password_usecase.dart';

void main() {
  group('DecryptItemPasswordUseCase', () {
    test('returns the same item (no-op)', () {
      final useCase = DecryptItemPasswordUseCase();

      const item = ItensEntity(
        userId: '',
        group: 'g',
        service: 's',
        login: 'l',
        password: 'cipher',
      );

      final result = useCase(item);
      expect(result, same(item));
    });
  });
}
