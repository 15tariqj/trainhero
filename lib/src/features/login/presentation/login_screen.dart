import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key, this.coldStart = false, this.error = false})
      : super(key: key);

  final bool coldStart;
  final bool error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }

  // ... Rest of the methods ...
}
