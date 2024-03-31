import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainhero/src/features/authentication/domain/app_user.dart';
import 'package:trainhero/src/utils/in_memory_store.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final _authState = InMemoryStore<AppUser?>(null);

  Stream<AppUser?> authStateChanges() => _authState.stream;
  AppUser? get currentUser => _authState.value;

  Future<bool>? emailAlreadyRegistered({
    required String email,
  }) async {
    final dio = Dio();
    String urlPw = dotenv.env['URL_PW'] ?? '';
    String headerPw = dotenv.env['HEADER_PW'] ?? '';
    Response<dynamic> response = await dio.get(
      'https://auth.trainhero.uk/checkEmail/$urlPw',
      options: Options(
        headers: {
          "hp": headerPw,
        },
      ),
      data: {
        "email": email,
      },
    );
    return response.data['emailAlreadyRegistered'] == 1;
  }

  Future<AppUser>? registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNo,
    String? pushToken,
  }) {
    return null;
  }

  Future<AppUser?>? login({
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
Stream<AppUser?> authStateChanges(AuthStateChangesRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
}
