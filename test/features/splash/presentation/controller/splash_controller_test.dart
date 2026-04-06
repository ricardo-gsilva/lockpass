import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashController', () {
    setUp(() {
      PackageInfo.setMockInitialValues(
        appName: 'LockPass',
        packageName: 'com.example.lockpass',
        version: '9.9.9',
        buildNumber: '999',
        buildSignature: 'test',
      );
    });

    test('initial state is not ready', () {
      final controller = SplashController();
      addTearDown(controller.close);

      expect(controller.state.ready, isFalse);
      expect(controller.state.packageInfo, isNull);
    });

    test('init emits ready state and waits minimum duration', () {
      fakeAsync((async) {
        final controller = SplashController();
        addTearDown(controller.close);

        final emitted = <SplashState>[];
        final sub = controller.stream.listen(emitted.add);
        addTearDown(sub.cancel);

        var completed = false;
        controller.init().then((_) => completed = true);

        async.flushMicrotasks();

        expect(emitted, hasLength(1));
        final state = emitted.single;
        expect(state.ready, isTrue);
        expect(state.packageInfo, isNotNull);
        expect(state.packageInfo!.version, '9.9.9');

        expect(completed, isFalse);

        async.elapse(const Duration(seconds: 5));
        async.flushMicrotasks();

        expect(completed, isTrue);
      });
    });
  });
}
