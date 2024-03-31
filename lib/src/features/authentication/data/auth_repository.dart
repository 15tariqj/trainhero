import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainhero/src/features/authentication/domain/user.dart';
import 'package:trainhero/src/utils/in_memory_store.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final _authState = InMemoryStore<User?>(null);

  Stream<User?> authStateChanges() => _authState.stream;
  User? get currentUser => _authState.value;

  Future<bool?>? emailAlreadyRegistered({
    required String email,
  }) async {
    // final dio = Dio();
    // String urlPw = dotenv.env['URL_PW'] ?? '';
    // String headerPw = dotenv.env['HEADER_PW'] ?? '';
    // Response<dynamic> response = await dio.get(
    //   'https://auth.trainhero.uk/checkEmail/$urlPw',
    //   options: Options(
    //     headers: {
    //       "hp": headerPw,
    //     },
    //   ),
    //   data: {
    //     "email": email,
    //   },
    // );
    return null;
  }

  Future<User?>? registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNo,
    String? pushToken,
  }) {
    return null;
  }

  Future<User?>? login({
    required String email,
    required String password,
  }) {
    return null;
  }

  Future<void> signOut() async {
    _authState.value = null;
  }

  Future<void> updatePaymentDetails({
    required String accountNo,
    required String sortCode,
  }) async {}

  void dispose() => _authState.close();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final auth = AuthRepository();
  ref.onDispose(() => auth.dispose());
  return auth;
}

@Riverpod(keepAlive: true)
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
