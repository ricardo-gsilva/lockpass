import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';

void main() {
  group('ItensEntity', () {
    test('isValid returns true only when service/login/password are present', () {
      const valid = ItensEntity(
        userId: 'u',
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );
      expect(valid.isValid(), isTrue);

      const invalidService = ItensEntity(
        userId: 'u',
        group: 'g',
        service: '',
        login: 'l',
        password: 'p',
      );
      expect(invalidService.isValid(), isFalse);

      const invalidLogin = ItensEntity(
        userId: 'u',
        group: 'g',
        service: 's',
        login: '',
        password: 'p',
      );
      expect(invalidLogin.isValid(), isFalse);

      const invalidPassword = ItensEntity(
        userId: 'u',
        group: 'g',
        service: 's',
        login: 'l',
        password: '',
      );
      expect(invalidPassword.isValid(), isFalse);
    });

    test('copyWith updates selected fields', () {
      const entity = ItensEntity(
        userId: 'u',
        group: 'g',
        service: 's',
        site: 'site',
        email: 'e',
        login: 'l',
        password: 'p',
        isDeleted: false,
      );

      // Note: `copyWith` uses `site ?? this.site`, so passing null does not clear
      // an existing site value. This test follows current behavior.
      final next = entity.copyWith(service: 's2', site: null, isDeleted: true);

      expect(next.userId, 'u');
      expect(next.group, 'g');
      expect(next.service, 's2');
      expect(next.site, 'site');
      expect(next.email, 'e');
      expect(next.isDeleted, isTrue);
    });

    test('isDifferentFrom detects changes', () {
      const base = ItensEntity(
        userId: 'u',
        group: 'g',
        service: 's',
        site: 'site',
        email: 'e',
        login: 'l',
        password: 'p',
        isDeleted: false,
      );

      expect(base.isDifferentFrom(base), isFalse);
      expect(base.isDifferentFrom(base.copyWith(group: 'g2')), isTrue);
      expect(base.isDifferentFrom(base.copyWith(service: 's2')), isTrue);
      expect(base.isDifferentFrom(base.copyWith(site: 'site2')), isTrue);
      expect(base.isDifferentFrom(base.copyWith(email: 'e2')), isTrue);
      expect(base.isDifferentFrom(base.copyWith(login: 'l2')), isTrue);
      expect(base.isDifferentFrom(base.copyWith(password: 'p2')), isTrue);
      expect(base.isDifferentFrom(base.copyWith(isDeleted: true)), isTrue);
    });

    test('supports value equality (Equatable)', () {
      expect(
        const ItensEntity(
          userId: 'u',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
        const ItensEntity(
          userId: 'u',
          group: 'g',
          service: 's',
          login: 'l',
          password: 'p',
        ),
      );
    });
  });
}
