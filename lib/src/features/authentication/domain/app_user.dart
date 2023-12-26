/// Simple class representing the user UID and email.
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.password,
  });
  final String uid;
  final String email;
  final String password;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.uid == uid &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ password.hashCode;

  @override
  String toString() => 'AppUser(uid: $uid, email: $email, password: $password)';
}
