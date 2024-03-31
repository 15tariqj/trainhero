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
          onPressed: () =>
              GoRouter.of(context).pushNamed(AppRoute.landing.name),
          child: Container(
            color: Colors.red,
            child: const Text("Landing screen"),
          ),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).pushNamed(AppRoute.mail.name),
          child: Container(
            color: Colors.red,
            child: const Text("Mail screen"),
          ),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context).pushNamed(AppRoute.home.name),
          child: Container(
            color: Colors.red,
            child: const Text("Home screen"),
          ),
        ),
        TextButton(
          onPressed: () =>
              GoRouter.of(context).pushNamed(AppRoute.settings.name),
          child: Container(
            color: Colors.red,
            child: const Text("Settings screen"),
          ),
        ),
        TextButton(
          onPressed: () =>
              GoRouter.of(context).pushNamed(AppRoute.loadingTicket.name),
          child: Container(
            color: Colors.red,
            child: const Text("Loading Ticket screen"),
          ),
        ),
        TextButton(
          onPressed: () => GoRouter.of(context)
              .pushNamed(AppRoute.message.name, pathParameters: {
            'image': "assets/th_dead.png",
            'heading': "There's been an issue.",
            'message':
                "Please try sending your PDF again or email help@trainhero.app for help.",
          }),
          child: Container(
            color: Colors.red,
            child: const Text("Message screen"),
          ),
        ),
      ],
    );
  }
}
