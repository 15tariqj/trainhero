/// Simple class representing the user UID and email.
class User {
  const User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.email == email &&
        other.password == password &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode =>
      email.hashCode ^
      password.hashCode ^
      firstName.hashCode ^
      lastName.hashCode;

  @override
  String toString() =>
      'User(email: $email, password: $password, firstName: $firstName, lastName: $lastName)';
}
