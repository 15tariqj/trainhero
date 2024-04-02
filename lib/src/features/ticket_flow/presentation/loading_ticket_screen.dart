import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:trainhero/main.dart';
import 'package:trainhero/src/features/ticket_flow/data/ticket_repository.dart';
import 'package:trainhero/src/routing/app_router.dart';

class LoadingTicketScreen extends HookConsumerWidget {
  const LoadingTicketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedFiles = ref.watch(sharedFileProvider);

    useEffect(() {
      if (sharedFiles.isNotEmpty) {
        ref.read(ticketResponseProvider.future).then(
          (ticketResponse) {
            ref.read(ticketResponseStateProvider.notifier).state = ticketResponse;
            ref.read(goRouterProvider).pushNamed(AppRoute.flexibleTicket.name);
          },
        ).catchError(
          (error) {},
        );
      }
      return null;
    }, [sharedFiles]);

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
