import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';
import 'package:lockpass/features/splash/presentation/pages/splash_screen_page.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../test_utils/widget_test_pump.dart';

class _TestSplashController extends SplashController {
  _TestSplashController({
    SplashState? seed,
    SplashState? emitOnInit,
  })  : _emitOnInit = emitOnInit,
        super() {
    if (seed != null) {
      emit(seed);
    }
  }

  final SplashState? _emitOnInit;

  @override
  Future<void> init() async {
    if (_emitOnInit != null) {
      emit(_emitOnInit!);
    }
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final transparentImageBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wwAAgMBApZ5lZ0AAAAASUVORK5CYII=',
  );

  Widget _app({required AssetBundle bundle}) {
    return DefaultAssetBundle(
      bundle: bundle,
      child: MaterialApp(
        routes: {
          AppRoutes.splash: (_) => const SplashScreenPage(),
          AppRoutes.login: (_) => const Scaffold(
                body: Text('LOGIN', key: Key('login-page')),
              ),
        },
        initialRoute: AppRoutes.splash,
      ),
    );
  }

  void _registerSplashController(SplashController controller) {
    if (getIt.isRegistered<SplashController>()) {
      getIt.unregister<SplashController>();
    }
    getIt.registerSingleton<SplashController>(controller);
  }

  group('SplashScreenPage (widget)', () {
    testWidgets('renders icon, app name, loader and empty version', (tester) async {
      final controller = _TestSplashController();
      addTearDown(controller.close);
      addTearDown(() {
        if (getIt.isRegistered<SplashController>()) {
          getIt.unregister<SplashController>();
        }
      });
      _registerSplashController(controller);

      await tester.pumpWidget(
        _app(bundle: _TestAssetBundle(Uint8List.fromList(transparentImageBytes))),
      );

      expect(find.byKey(CoreKeys.iconAppSplashScreen), findsOneWidget);
      expect(find.byKey(CoreKeys.textAppNameSplashScreen), findsOneWidget);
      expect(find.text(CoreStrings.appName), findsOneWidget);
      expect(find.byKey(CoreKeys.circularProgressSplashScreen), findsOneWidget);
      expect(find.byKey(CoreKeys.appVersionSplashScreen), findsOneWidget);

      final versionText = tester.widget<Text>(
        find.descendant(
          of: find.byKey(CoreKeys.appVersionSplashScreen),
          matching: find.byType(Text),
        ),
      );
      expect(versionText.data, 'v');
    });

    testWidgets('shows app version when state has packageInfo', (tester) async {
      final info = PackageInfo(
        appName: 'LockPass',
        packageName: 'com.example.lockpass',
        version: '1.2.3',
        buildNumber: '42',
      );

      final controller = _TestSplashController(
        seed: SplashState(packageInfo: info),
      );
      addTearDown(controller.close);
      addTearDown(() {
        if (getIt.isRegistered<SplashController>()) {
          getIt.unregister<SplashController>();
        }
      });
      _registerSplashController(controller);

      await tester.pumpWidget(
        _app(bundle: _TestAssetBundle(Uint8List.fromList(transparentImageBytes))),
      );

      final versionText = tester.widget<Text>(
        find.descendant(
          of: find.byKey(CoreKeys.appVersionSplashScreen),
          matching: find.byType(Text),
        ),
      );
      expect(versionText.data, 'v1.2.3');
    });

    testWidgets('navigates to login after ready becomes true (2s delay)', (tester) async {
      final controller = _TestSplashController(
        seed: const SplashState(ready: false),
        emitOnInit: const SplashState(ready: true),
      );
      addTearDown(controller.close);
      addTearDown(() {
        if (getIt.isRegistered<SplashController>()) {
          getIt.unregister<SplashController>();
        }
      });
      _registerSplashController(controller);

      await tester.pumpWidget(
        _app(bundle: _TestAssetBundle(Uint8List.fromList(transparentImageBytes))),
      );
      await tester.pump(); // run post frame callback -> controller.init()

      expect(find.byKey(const Key('login-page')), findsNothing);

      await tester.pump(const Duration(seconds: 2));
      await pumpModal(tester);

      expect(find.byKey(const Key('login-page')), findsOneWidget);
    });
  });
}
