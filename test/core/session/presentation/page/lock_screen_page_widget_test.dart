import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_icons.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/core/session/domain/usecases/get_pin_status_session_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_credentials_usecase.dart';
import 'package:lockpass/core/session/domain/usecases/unlock_with_pin_usecase.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';
import 'package:lockpass/core/session/presentation/page/lock_screen_page.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';

import '../../../../test_utils/widget_test_pump.dart';

class _FakeUnlockWithPinUseCase implements UnlockWithPinUseCase {
  @override
  Future<bool> call(String pin) async => true;
}

class _FakeUnlockWithCredentialsUseCase implements UnlockWithCredentialsUseCase {
  @override
  Future<bool> call({required String email, required String password}) async => true;
}

class _FakeGetLockTimeoutSessionUseCase implements GetLockTimeoutSessionUseCase {
  @override
  int call() => 60;
}

class _FakeGetPinStatusSessionUseCase implements GetPinStatusSessionUseCase {
  @override
  Future<bool> call() async => true;
}

class _TestLockScreenController extends LockScreenController {
  _TestLockScreenController({required bool hasPin})
      : _hasPin = hasPin,
        super(
          unlockWithPinUseCase: _FakeUnlockWithPinUseCase(),
          unlockWithCredentialUseCase: _FakeUnlockWithCredentialsUseCase(),
          getLockTimeoutSessionUseCase: _FakeGetLockTimeoutSessionUseCase(),
          getPinStatusSessionUseCase: _FakeGetPinStatusSessionUseCase(),
        );

  final bool _hasPin;

  int unlockCalls = 0;
  ({bool pinOrEmailAndPassword, String? pin, String? email, String? password})? lastUnlockArgs;

  @override
  Future<bool> getPinVerification() async {
    emit(state.copyWith(status: const LockScreenInitial()));
    return _hasPin;
  }

  @override
  Future<void> unlock({
    required bool pinOrEmailAndPassword,
    String? pin,
    String? email,
    String? password,
  }) async {
    unlockCalls += 1;
    lastUnlockArgs = (
      pinOrEmailAndPassword: pinOrEmailAndPassword,
      pin: pin,
      email: email,
      password: password,
    );

    emit(state.copyWith(status: const LockScreenLoading()));
    emit(state.copyWith(status: const LockScreenSuccess()));
  }
}

class _TestAssetBundle extends CachingAssetBundle {
  _TestAssetBundle(this._transparentPngBytes);

  final Uint8List _transparentPngBytes;
  static final StandardMessageCodec _codec = StandardMessageCodec();

  ByteData _byteDataFromList(Uint8List bytes) => ByteData.view(bytes.buffer);

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin') {
      final message = <String, List<Map<String, Object?>>>{
        CoreStrings.iconApp: <Map<String, Object?>>[
          <String, Object?>{'asset': CoreStrings.iconApp, 'dpr': null},
        ],
      };
      final encoded = _codec.encodeMessage(message);
      if (encoded == null) {
        throw FlutterError('Failed to encode AssetManifest.bin');
      }
      return encoded;
    }

    if (key == 'AssetManifest.json') {
      final json = jsonEncode({
        CoreStrings.iconApp: [
          {'asset': CoreStrings.iconApp, 'dpr': null},
        ],
      });
      return _byteDataFromList(Uint8List.fromList(utf8.encode(json)));
    }

    if (key == CoreStrings.iconApp) {
      return _byteDataFromList(_transparentPngBytes);
    }

    throw FlutterError('Unable to load asset: $key');
  }
}

Uint8List _transparentPng() {
  // 1x1 transparent png
  return base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMB/6Xb3W0AAAAASUVORK5CYII=',
  );
}

class _PushLockScreenHost extends StatefulWidget {
  const _PushLockScreenHost();

  @override
  State<_PushLockScreenHost> createState() => _PushLockScreenHostState();
}

class _PushLockScreenHostState extends State<_PushLockScreenHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const LockScreenPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('HOST'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    if (getIt.isRegistered<LockScreenController>()) {
      getIt.unregister<LockScreenController>();
    }
  });

  group('LockScreenPage (widget)', () {
    testWidgets('when hasPin=true, shows pin flow by default and calls unlock with pin', (tester) async {
      final controller = _TestLockScreenController(hasPin: true);
      addTearDown(controller.close);
      getIt.registerSingleton<LockScreenController>(controller);

      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(_transparentPng()),
          child: const MaterialApp(
            home: _PushLockScreenHost(),
          ),
        ),
      );

      // Open lock screen route, then run its post-frame callback that sets _usePin/_hasPin.
      await pumpModal(tester);

      expect(find.byIcon(CoreIcons.pin), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, '12345');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.unlockAction));
      await tester.pump();

      expect(controller.unlockCalls, 1);
      expect(controller.lastUnlockArgs?.pinOrEmailAndPassword, isTrue);
      expect(controller.lastUnlockArgs?.pin, '12345');
    });

    testWidgets('when hasPin=false, shows email/password flow and calls unlock with credentials', (tester) async {
      final controller = _TestLockScreenController(hasPin: false);
      addTearDown(controller.close);
      getIt.registerSingleton<LockScreenController>(controller);

      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: _TestAssetBundle(_transparentPng()),
          child: const MaterialApp(
            home: _PushLockScreenHost(),
          ),
        ),
      );

      await pumpModal(tester);

      expect(find.byIcon(CoreIcons.person), findsOneWidget);
      expect(find.byIcon(CoreIcons.lock), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'user@example.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'pw123456');
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, CoreStrings.unlockAction));
      await tester.pump();

      expect(controller.unlockCalls, 1);
      expect(controller.lastUnlockArgs?.pinOrEmailAndPassword, isFalse);
      expect(controller.lastUnlockArgs?.email, 'user@example.com');
      expect(controller.lastUnlockArgs?.password, 'pw123456');
    });
  });
}
