import 'package:trainhero/src/features/authentication/domain/models/user.dart';

/// Fake user class used to simulate a user account on the backend
class FakeUser extends User {
  FakeUser({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
  });
}
