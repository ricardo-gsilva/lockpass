import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/widgets/pin_login_bottom_sheet.dart';

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
  _TestLoginController({void Function(String pin)? onPinLogin})
      : _onPinLogin = onPinLogin,
        super(
          loginWithEmailUseCase: _FakeLoginWithEmailUseCase(),
          checkPinAvailabilityUseCase: _FakeCheckPinAvailabilityUseCase(),
          registerUserUseCase: _FakeRegisterUserUseCase(),
          resetPasswordUseCase: _FakeResetPasswordUseCase(),
          loginWithPinUseCase: _FakeLoginWithPinUseCase(),
        );

  final void Function(String pin)? _onPinLogin;

  @override
  Future<void> loginWithPin(String typedPin) async {
    _onPinLogin?.call(typedPin);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app(LoginController controller) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(
          value: controller,
          child: const PinLoginBottomSheet(),
        ),
      ),
    );
  }

  group('PinLoginBottomSheet (widget)', () {
    testWidgets('disables submit until pin length >= 5', (tester) async {
      final controller = _TestLoginController();
      addTearDown(controller.close);

      await tester.pumpWidget(_app(controller));

      ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField), '1234');
      await tester.pump();

      button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);

      await tester.enterText(find.byType(TextFormField), '12345');
      await tester.pump();

      button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping submit calls loginWithPin with typed value', (tester) async {
      String? captured;
      final controller = _TestLoginController(onPinLogin: (pin) => captured = pin);
      addTearDown(controller.close);

      await tester.pumpWidget(_app(controller));

      await tester.enterText(find.byType(TextFormField), '98765');
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(captured, '98765');
    });
  });
}

