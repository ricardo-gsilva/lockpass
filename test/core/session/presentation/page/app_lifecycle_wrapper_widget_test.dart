import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/navigation/app_routes.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/core/session/presentation/page/app_lifecycle_wrapper.dart';
import 'package:lockpass/core/session/session_lock_service.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockUser extends Mock implements User {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLifecycleWrapper (widget)', () {
    setUp(() async {
      await getIt.reset();
      SharedPreferences.setMockInitialValues({
        SharedPreferencesDatasource.lockTimeoutSeconds: 1,
      });

      final prefs = await SharedPreferences.getInstance();
      getIt.registerSingleton<SharedPreferences>(prefs);
      getIt.registerSingleton<SharedPreferencesDatasource>(
        SharedPreferencesDatasource(sharedPreferences: prefs),
      );
      getIt.registerSingleton<GetLockTimeoutSessionUseCase>(
        GetLockTimeoutSessionUseCase(getIt<SharedPreferencesDatasource>()),
      );
      getIt.registerSingleton<SessionLockService>(SessionLockService()..lock());
    });

    Widget _app({
      required AuthService authService,
      required String initialRoute,
    }) {
      if (getIt.isRegistered<AuthService>()) {
        getIt.unregister<AuthService>();
      }
      getIt.registerSingleton<AuthService>(authService);

      return MaterialApp(
        navigatorKey: AppRoutes.navigatorKey,
        initialRoute: initialRoute,
        routes: {
          AppRoutes.splash: (_) => const Scaffold(body: Text('SPLASH', key: Key('splash'))),
          AppRoutes.login: (_) => const Scaffold(body: Text('LOGIN', key: Key('login'))),
          AppRoutes.lockScreen: (_) => const Scaffold(body: Text('LOCK', key: Key('lock'))),
        },
        builder: (context, child) => AppLifecycleWrapper(child: child!),
      );
    }

    testWidgets('never navigates to lock screen while on login (even if locked + authenticated)', (tester) async {
      final authService = _MockAuthService();
      final user = _MockUser();
      when(() => authService.currentUser).thenReturn(user);

      await tester.pumpWidget(_app(authService: authService, initialRoute: AppRoutes.login));
      expect(find.byKey(const Key('login')), findsOneWidget);

      // Wait past the lock timeout; should not navigate to lock screen.
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      expect(find.byKey(const Key('lock')), findsNothing);
      expect(find.byKey(const Key('login')), findsOneWidget);
    });

    testWidgets('never navigates to lock screen while on splash', (tester) async {
      final authService = _MockAuthService();
      final user = _MockUser();
      when(() => authService.currentUser).thenReturn(user);

      await tester.pumpWidget(_app(authService: authService, initialRoute: AppRoutes.splash));

      await tester.pump();
      expect(find.byKey(const Key('splash')), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pump();

      expect(find.byKey(const Key('lock')), findsNothing);
      expect(find.byKey(const Key('splash')), findsOneWidget);
    });
  });
}
