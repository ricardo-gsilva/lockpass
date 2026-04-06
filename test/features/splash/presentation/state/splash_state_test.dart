import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  group('SplashState', () {
    test('default values', () {
      const state = SplashState();
      expect(state.ready, isFalse);
      expect(state.packageInfo, isNull);
    });

    test('copyWith updates ready', () {
      const state = SplashState();
      final next = state.copyWith(ready: true);
      expect(next.ready, isTrue);
      expect(next.packageInfo, isNull);
    });

    test('copyWith keeps previous values when null', () {
      final info = PackageInfo(
        appName: 'LockPass',
        packageName: 'com.example.lockpass',
        version: '1.2.3',
        buildNumber: '42',
      );
      final state = SplashState(packageInfo: info, ready: true);

      final next = state.copyWith(packageInfo: null, ready: null);
      expect(next.packageInfo, same(info));
      expect(next.ready, isTrue);
    });

    test('supports value equality (Equatable)', () {
      final info = PackageInfo(
        appName: 'LockPass',
        packageName: 'com.example.lockpass',
        version: '1.2.3',
        buildNumber: '42',
      );

      final a = SplashState(packageInfo: info, ready: true);
      final b = SplashState(packageInfo: info, ready: true);
      final c = SplashState(packageInfo: info, ready: false);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
