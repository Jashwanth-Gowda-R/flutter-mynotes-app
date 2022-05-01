import 'package:test/test.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

void main() {
  group('Mock Auth', () {
    final provider = MockAuthProvider();

    test('should not be initalized to begin with', () {
      expect(provider.isInitailized, false);
    });

    test('cannot logout if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('should be able to initalized', () async {
      await provider.initialize();
      expect(provider.isInitailized, true);
    });

    test('user should be null upon initialization', () {
      expect(provider.currentUser, null);
    });

    test('should be able to initialze in less than 2 sec', () async {
      await provider.initialize();
      expect(provider.isInitailized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'webdevjash6@gmail.com',
        password: 'webdevjash',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'webdevjash6@gmail.com',
        password: 'webdevjash6',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = provider.createUser(
        email: 'webdev',
        password: 'webdevjas',
      );
      expect(provider.currentUser, user);
    });
    test('logged in user should be able to get verified', () async {
      await provider.sendEmailverification();
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

    test('should be able top log out and login again', () async {
      await provider.logOut();
      await provider.logIn(email: 'email', password: 'password');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitailized => _isInitialized;

  AuthUser? _user;

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    if (!isInitailized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    if (!isInitailized) throw NotInitializedException();
    if (email == 'webdevjash6@gmail.com') throw UserNotFoundAuthException();
    if (password == 'webdevjash6') throw WrongPasswordAuthException();
    var user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitailized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailverification() async {
    if (!isInitailized) throw NotInitializedException();
    final user = _user;
    if (_user == null) throw UserNotFoundAuthException();
    var newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
