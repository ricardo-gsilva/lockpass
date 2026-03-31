import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/features/login/domain/usecases/check_pin_availability_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_email_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/login_with_pin_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/register_user_usecase.dart';
import 'package:lockpass/features/login/domain/usecases/reset_password_usecase.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/login/presentation/state/auth_status.dart';
import 'package:lockpass/features/login/presentation/widgets/create_account_bottom_sheet.dart';

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
    void Function(String email, String password)? onRegister,
  })  : _onRegister = onRegister,
        super(
          loginWithEmailUseCase: _FakeLoginWithEmailUseCase(),
          checkPinAvailabilityUseCase: _FakeCheckPinAvailabilityUseCase(),
          registerUserUseCase: _FakeRegisterUserUseCase(),
          resetPasswordUseCase: _FakeResetPasswordUseCase(),
          loginWithPinUseCase: _FakeLoginWithPinUseCase(),
        );

  final void Function(String email, String password)? _onRegister;

  @override
  Future<void> register({required String email, required String password}) async {
    _onRegister?.call(email, password);
    emit(state.copyWith(status: const AccountCreated()));
  }
}

class _OpenBottomSheetHost extends StatefulWidget {
  const _OpenBottomSheetHost({
    required this.controller,
    required this.onResult,
  });

  final LoginController controller;
  final ValueChanged<({String email})?> onResult;

  @override
  State<_OpenBottomSheetHost> createState() => _OpenBottomSheetHostState();
}

class _OpenBottomSheetHostState extends State<_OpenBottomSheetHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await showModalBottomSheet<({String email})>(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider.value(
          value: widget.controller,
          child: const CreateAccountBottomSheet(),
        ),
      );
      widget.onResult(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('HOST')),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget _app({
    required LoginController controller,
    required ValueChanged<({String email})?> onResult,
  }) {
    return MaterialApp(
      home: _OpenBottomSheetHost(
        controller: controller,
        onResult: onResult,
      ),
    );
  }

  group('CreateAccountBottomSheet (widget)', () {
    testWidgets('submits email/password and returns email on success', (tester) async {
      String? capturedEmail;
      String? capturedPassword;
      ({String email})? result;

      final controller = _TestLoginController(
        onRegister: (email, password) {
          capturedEmail = email;
          capturedPassword = password;
        },
      );
      addTearDown(controller.close);

      await tester.pumpWidget(
        _app(
          controller: controller,
          onResult: (value) => result = value,
        ),
      );
      await tester.pumpAndSettle(); // open sheet

      expect(find.text(CoreStrings.register1), findsOneWidget);
      expect(find.text(CoreStrings.register2), findsOneWidget);
      expect(find.text(CoreStrings.cancel), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).at(0), 'user@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), '123456');
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(capturedEmail, 'user@test.com');
      expect(capturedPassword, '123456');
      expect(result?.email, 'user@test.com');
      expect(find.text(CoreStrings.register1), findsNothing);
    });
  });
}
