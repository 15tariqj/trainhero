import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trainhero/src/routing/app_router.dart';

class LoadingTicketScreen extends ConsumerStatefulWidget {
  const LoadingTicketScreen({super.key});

  @override
  ConsumerState<LoadingTicketScreen> createState() =>
      _LoadingTicketScreenState();
}

class _LoadingTicketScreenState extends ConsumerState<LoadingTicketScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(goRouterProvider).goNamed(AppRoute.flexibleTicket.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C2C44),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/trainHeroLogo.png',
              height: 100,
            ),
            const SizedBox(
              height: 55,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "I'm Loading the Ticket",
                  style: TextStyle(
                    fontSize: 300,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'This may take a while on a slower connection.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            LoadingAnimationWidget.waveDots(color: Colors.white, size: 70)
          ],
        ),
      ),
    );
  }
}
