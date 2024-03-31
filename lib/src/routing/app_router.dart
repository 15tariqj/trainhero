import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainhero/dev_screen.dart';
import 'package:trainhero/src/features/authentication/data/auth_repository.dart';
import 'package:trainhero/src/features/home/presentation/home_screen.dart';
import 'package:trainhero/src/features/landing/presentation/landing_screen.dart';
import 'package:trainhero/src/features/loading_ticket/presentation/loading_ticket_screen.dart';
import 'package:trainhero/src/features/mail/presentation/mail_screen.dart';
import 'package:trainhero/src/features/message/presentation/message_screen.dart';
import 'package:trainhero/src/features/settings/presentation/settings_screen.dart';
import 'package:trainhero/src/routing/go_router_refresh_stream.dart';
import 'package:trainhero/src/routing/not_found_screen.dart';

part 'app_router.g.dart';

enum AppRoute {
  dev,
  home,
  landing,
  mail,
  settings,
  loadingTicket,
  message,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/dev',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/signIn') {
          return '/';
        }
      } else {
        if (path == '/account') {
          return '/';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/landing',
        name: AppRoute.landing.name,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/dev',
        name: AppRoute.dev.name,
        builder: (context, state) => const DevScreen(),
      ),
      GoRoute(
        path: '/mail',
        name: AppRoute.mail.name,
        builder: (context, state) => const MailScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: AppRoute.settings.name,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/loadingTicket',
        name: AppRoute.loadingTicket.name,
        builder: (context, state) => const LoadingTicketScreen(),
      ),
      GoRoute(
        path: '/message/:image/:message/:heading',
        name: AppRoute.message.name,
        builder: (context, state) => MessageScreen(
          message: state.pathParameters['message'] ?? '',
          heading: state.pathParameters['heading'] ?? '',
          image: state.pathParameters['image'] ?? '',
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
