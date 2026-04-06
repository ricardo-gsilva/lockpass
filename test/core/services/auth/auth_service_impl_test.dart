import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/services/auth/auth_service_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockUser extends Mock implements User {}

class _FakeUserCredential extends Fake implements UserCredential {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      EmailAuthProvider.credential(
        email: 'fallback@example.com',
        password: 'pw',
      ),
    );
  });

  group('AuthServiceImpl', () {
    late _MockFirebaseAuth auth;
    late AuthServiceImpl service;

    setUp(() {
      auth = _MockFirebaseAuth();
      service = AuthServiceImpl(auth: auth);
    });

    test('currentUserId returns empty when user is null', () {
      when(() => auth.currentUser).thenReturn(null);
      expect(service.currentUserId, '');
    });

    test('currentUserId and currentUserEmail read from injected auth', () {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.uid).thenReturn('uid-1');
      when(() => user.email).thenReturn('a@b.com');

      expect(service.currentUserId, 'uid-1');
      expect(service.currentUserEmail, 'a@b.com');
    });

    test('reauthenticateWithPassword returns false when currentUser is null', () async {
      when(() => auth.currentUser).thenReturn(null);

      final ok = await service.reauthenticateWithPassword(
        email: 'a@b.com',
        password: 'pw',
      );
      expect(ok, isFalse);
    });

    test('reauthenticateWithPassword throws AuthException with mapped message', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.reauthenticateWithCredential(any())).thenThrow(
        FirebaseAuthException(code: 'wrong-password'),
      );

      await expectLater(
        () => service.reauthenticateWithPassword(email: 'a@b.com', password: 'pw'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            CoreStrings.fInvalidLoginCredentials,
          ),
        ),
      );
    });

    test('signOut returns true on success and false on error', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});
      expect(await service.signOut(), isTrue);

      when(() => auth.signOut()).thenThrow(Exception('fail'));
      expect(await service.signOut(), isFalse);
    });

    test('register throws AuthException with mapped message', () async {
      when(() => auth.createUserWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      await expectLater(
        () => service.register('bad', 'pw'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            CoreStrings.fEmailInvalid,
          ),
        ),
      );
    });

    test('login throws AuthException with mapped message', () async {
      when(() => auth.signInWithEmailAndPassword(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(code: 'invalid-login-credentials'));

      await expectLater(
        () => service.login('a@b.com', 'pw'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            CoreStrings.fInvalidLoginCredentials,
          ),
        ),
      );
    });

    test('resetPassword throws AuthException with mapped message', () async {
      when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(FirebaseAuthException(code: 'network-request-failed'));

      await expectLater(
        () => service.resetPassword('a@b.com'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            CoreStrings.noConnection,
          ),
        ),
      );
    });

    test('updatePassword reauthenticates then calls updatePassword', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.email).thenReturn('a@b.com');
      when(() => user.reauthenticateWithCredential(any())).thenAnswer((_) async => _FakeUserCredential());
      when(() => user.updatePassword(any())).thenAnswer((_) async {});

      await service.updatePassword(currentPassword: 'old', newPassword: 'new');

      verify(() => user.reauthenticateWithCredential(any())).called(1);
      verify(() => user.updatePassword('new')).called(1);
    });

    test('deleteAccount throws AuthException with mapped message', () async {
      final user = _MockUser();
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.delete()).thenThrow(FirebaseAuthException(code: 'requires-recent-login'));

      await expectLater(
        () => service.deleteAccount(),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            CoreStrings.sessionExpired,
          ),
        ),
      );
    });
  });
}
