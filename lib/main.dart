import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trainhero/src/routing/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

final sharedFileProvider = StateProvider<List<SharedMediaFile>>((ref) => []);

void main() async {
  await dotenv.load();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intentSub = useState<StreamSubscription?>(null);

    useEffect(() {
      // Listen to media sharing coming from outside the app while the app is in the memory.
      intentSub.value = ReceiveSharingIntent.getMediaStream().listen((value) {
        ref.read(sharedFileProvider.notifier).state = value;
        print(value.map((f) => f.toMap()));
        // Navigate to the loadingTicket screen when a file is received
        if (value.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(goRouterProvider).goNamed(AppRoute.loadingTicket.name);
          });
        }
      }, onError: (err) {
        print("getIntentDataStream error: $err");
      });

      // Get the media sharing coming from outside the app while the app is closed.
      ReceiveSharingIntent.getInitialMedia().then((value) {
        ref.read(sharedFileProvider.notifier).state = value;
        print(value.map((f) => f.toMap()));
        // Tell the library that we are done processing the intent.
        ReceiveSharingIntent.reset();
        if (value.isNotEmpty) {
          // Navigate to the loadingTicket screen when a file is received
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(goRouterProvider).goNamed(AppRoute.loadingTicket.name);
          });
        }
      });

      return () {
        intentSub.value?.cancel();
      };
    }, []);

    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      title: 'TrainHero',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xff373759),
      ),
    );
  }
}
