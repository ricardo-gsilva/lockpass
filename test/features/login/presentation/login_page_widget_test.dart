import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_keys.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/pages/login_page.dart';
import 'package:lockpass/features/login/presentation/state/auth_state.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';

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

class _FakeCheckPinAvailabilityUseCase implements CheckPinAvailabilityUseCase {
  @override
  Future<bool> call() async => false;
}

class _FakeLoginWithEmailUseCase implements LoginWithEmailUseCase {
  @override
  Future<void> call({required String email, required String password}) async {}
}

class _FakeLoginWithPinUseCase implements LoginWithPinUseCase {
  @override
  Future<bool> call(String typedPin) async => false;
}

class _FakeRegisterUserUseCase implements RegisterUserUseCase {
  @override
  Future<void> call({required String email, required String password}) async {}
}

class _FakeResetPasswordUseCase implements ResetPasswordUseCase {
  @override
  Future<void> call(String email) async {}
}

class _TestLoginController extends LoginController {
  _TestLoginController({
    bool canAuthWithPinOnInit = false,
    void Function(String email, String password)? onEmailLogin,
    bool emitEmailAuthenticatedOnEmailLogin = false,
  })  : _canAuthWithPinOnInit = canAuthWithPinOnInit,
        _onEmailLogin = onEmailLogin,
        _emitEmailAuthenticatedOnEmailLogin = emitEmailAuthenticatedOnEmailLogin,
        super(
          loginWithEmailUseCase: _FakeLoginWithEmailUseCase(),
          checkPinAvailabilityUseCase: _FakeCheckPinAvailabilityUseCase(),
          registerUserUseCase: _FakeRegisterUserUseCase(),
          resetPasswordUseCase: _FakeResetPasswordUseCase(),
          loginWithPinUseCase: _FakeLoginWithPinUseCase(),
        );

  final bool _canAuthWithPinOnInit;
  final void Function(String email, String password)? _onEmailLogin;
  final bool _emitEmailAuthenticatedOnEmailLogin;

  @override
  Future<void> init() async {
    if (_canAuthWithPinOnInit) {
      emit(state.copyWith(canAuthWithPin: true));
    }
  }

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    _onEmailLogin?.call(email, password);
    if (_emitEmailAuthenticatedOnEmailLogin) {
      emit(state.copyWith(status: const EmailAuthenticated()));
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final transparentImageBytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wwAAgMBApZ5lZ0AAAAASUVORK5CYII=',
  );

  Widget _app() {
    return DefaultAssetBundle(
      bundle: _TestAssetBundle(Uint8List.fromList(transparentImageBytes)),
      child: MaterialApp(
        routes: {
          AppRoutes.login: (_) => const LoginPage(),
          AppRoutes.home: (_) => const Scaffold(
                body: Text('HOME', key: Key('home-page')),
              ),
        },
        initialRoute: AppRoutes.login,
      ),
    );
  }

  void _registerLoginController(LoginController controller) {
    if (getIt.isRegistered<LoginController>()) {
      getIt.unregister<LoginController>();
    }
    getIt.registerSingleton<LoginController>(controller);
  }

  tearDown(() {
    if (getIt.isRegistered<LoginController>()) {
      getIt.unregister<LoginController>();
    }
  });

  group('LoginPage (widget)', () {
    testWidgets('renders base UI and hides pin entry when unavailable', (tester) async {
      _registerLoginController(_TestLoginController(canAuthWithPinOnInit: false));

      await tester.pumpWidget(_app());
      await tester.pump();

      expect(find.byKey(CoreKeys.appIconLoginPage), findsOneWidget);
      expect(find.byKey(CoreKeys.registerHereLoginPage), findsOneWidget);
      expect(find.byKey(CoreKeys.forgotPasswordLoginPage), findsOneWidget);
      expect(find.byKey(CoreKeys.buttonEnterLoginPage), findsOneWidget);
      expect(find.byKey(CoreKeys.enterWithPin), findsNothing);
    });

    testWidgets('shows pin entry when canAuthWithPin is true', (tester) async {
      _registerLoginController(_TestLoginController(canAuthWithPinOnInit: true));

      await tester.pumpWidget(_app());
      await tester.pump();

      expect(find.byKey(CoreKeys.enterWithPin), findsOneWidget);
    });

    testWidgets('tapping enter calls loginWithEmailAndPassword and navigates on success', (tester) async {
      String? capturedEmail;
      String? capturedPassword;

      _registerLoginController(
        _TestLoginController(
          onEmailLogin: (email, password) {
            capturedEmail = email;
            capturedPassword = password;
          },
          emitEmailAuthenticatedOnEmailLogin: true,
        ),
      );

      await tester.pumpWidget(_app());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).at(0), 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');

      await tester.tap(
        find.descendant(
          of: find.byKey(CoreKeys.buttonEnterLoginPage),
          matching: find.byType(ElevatedButton),
        ),
      );
      await tester.pumpAndSettle();

      expect(capturedEmail, 'user@test.com');
      expect(capturedPassword, '123456');
      expect(find.byKey(const Key('home-page')), findsOneWidget);
    });
  });
}

