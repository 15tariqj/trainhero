import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainhero/dev_screen.dart';
import 'package:trainhero/src/features/authentication/data/auth_repository.dart';
import 'package:trainhero/src/features/landing/presentation/landing_screen.dart';
import 'package:trainhero/src/features/mail/presentation/mail_screen.dart';
import 'package:trainhero/src/routing/go_router_refresh_stream.dart';
import 'package:trainhero/src/routing/not_found_screen.dart';

part 'app_router.g.dart';

enum AppRoute { landing, dev, mail }

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
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
