import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainhero/src/routing/app_router.dart';

class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => GoRouter.of(context).goNamed(AppRoute.landing.name),
          child: Container(
            color: Colors.red,
            child: const Text("Landing screen"),
          ),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).goNamed(AppRoute.mail.name),
          child: Container(
            color: Colors.red,
            child: const Text("Mail screen"),
          ),
        )
      ],
    );
  }
}
