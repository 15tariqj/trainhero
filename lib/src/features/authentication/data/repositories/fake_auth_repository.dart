import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainhero/src/exceptions/app_exception.dart';
import 'package:trainhero/src/features/authentication/domain/models/fake_user.dart';
import 'package:trainhero/src/features/authentication/domain/models/user.dart';
import 'package:trainhero/src/utils/delay.dart';
import 'package:trainhero/src/utils/in_memory_store.dart';

part 'fake_auth_repository.g.dart';

class FakeAuthRepository {
  FakeAuthRepository({this.addDelay = true});
  final bool addDelay;
  final _authState = InMemoryStore<User?>(null);

  Stream<User?> fakeAuthStateChanges() => _authState.stream;
  User? get currentUser => _authState.value;

  // List to keep track of all user accounts
  final List<User> _users = [];

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await delay(addDelay);
    // check the given credentials agains each registered user
    for (final u in _users) {
      // matching email and password
      if (u.email == email && u.firstName == password) {
        _authState.value = u;
        return;
      }
      // same email, wrong password
      if (u.email == email && u.password != password) {
        throw WrongPasswordException();
      }
    }
    throw UserNotFoundException();
  }

  Future<void> createUser(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    await delay(addDelay);
    // check if the email is already in use
    for (final u in _users) {
      if (u.email == email) {
        throw EmailAlreadyInUseException();
      }
    }
    // minimum password length requirement
    if (password.length < 8) {
      throw WeakPasswordException();
    }
    // create new user
    _createNewUser(
      email,
      password,
      firstName,
      lastName,
    );
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  void dispose() => _authState.close();

  void _createNewUser(
    String email,
    String password,
    String firstName,
    String lastName,
  ) {
    // create new user
    final user = FakeUser(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    // register it
    _users.add(user);
    // update the auth state
    _authState.value = user;
  }
}

@Riverpod(keepAlive: true)
FakeAuthRepository fakeAuthRepository(FakeAuthRepositoryRef ref) {
  final fakeAuth = FakeAuthRepository();
  ref.onDispose(() => fakeAuth.dispose());
  return fakeAuth;
}

@Riverpod(keepAlive: true)
Stream<User?> fakeAuthStateChanges(FakeAuthStateChangesRef ref) {
  final fakeAuthRepository = ref.watch(fakeAuthRepositoryProvider);
  return fakeAuthRepository.fakeAuthStateChanges();
}
