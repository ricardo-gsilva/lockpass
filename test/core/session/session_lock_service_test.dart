import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/session/session_lock_service.dart';

void main() {
  group('SessionLockService', () {
    test('starts unlocked', () {
      final service = SessionLockService();
      expect(service.isLocked, isFalse);
    });

    test('lock/unlock toggles state', () {
      final service = SessionLockService();
      service.lock();
      expect(service.isLocked, isTrue);

      service.unlock();
      expect(service.isLocked, isFalse);
    });
  });
}

