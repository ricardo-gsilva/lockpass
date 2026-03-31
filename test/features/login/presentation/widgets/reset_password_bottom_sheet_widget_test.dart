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
import 'package:lockpass/features/login/presentation/widgets/reset_password_bottom_sheet.dart';

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
  _TestLoginController({void Function(String email)? onResetPassword})
      : _onResetPassword = onResetPassword,
        super(
          loginWithEmailUseCase: _FakeLoginWithEmailUseCase(),
          checkPinAvailabilityUseCase: _FakeCheckPinAvailabilityUseCase(),
          registerUserUseCase: _FakeRegisterUserUseCase(),
          resetPasswordUseCase: _FakeResetPasswordUseCase(),
          loginWithPinUseCase: _FakeLoginWithPinUseCase(),
        );

  final void Function(String email)? _onResetPassword;

  @override
  Future<void> resetPassword({required String email}) async {
    _onResetPassword?.call(email);
    emit(state.copyWith(status: const PasswordResetSent()));
  }
}

class _OpenBottomSheetHost extends StatefulWidget {
  const _OpenBottomSheetHost({
    required this.controller,
    required this.sheet,
  });

  final LoginController controller;
  final Widget sheet;

  @override
  State<_OpenBottomSheetHost> createState() => _OpenBottomSheetHostState();
}

class _OpenBottomSheetHostState extends State<_OpenBottomSheetHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider.value(
          value: widget.controller,
          child: widget.sheet,
        ),
      );
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

  Widget _app(LoginController controller) {
    return MaterialApp(
      home: _OpenBottomSheetHost(
        controller: controller,
        sheet: const ResetPasswordBottomSheet(),
      ),
    );
  }

  group('ResetPasswordBottomSheet (widget)', () {
    testWidgets('submits email and closes on success', (tester) async {
      String? captured;
      final controller = _TestLoginController(onResetPassword: (email) => captured = email);
      addTearDown(controller.close);

      await tester.pumpWidget(_app(controller));
      await tester.pumpAndSettle(); // open sheet

      expect(find.text(CoreStrings.resetPassword), findsOneWidget);
      expect(find.text(CoreStrings.send), findsOneWidget);
      expect(find.text(CoreStrings.cancel), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'user@test.com');
      await tester.pump();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(captured, 'user@test.com');
      expect(find.text(CoreStrings.resetPassword), findsNothing);
    });
  });
}
