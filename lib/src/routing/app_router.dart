import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trainhero/dev_screen.dart';
import 'package:trainhero/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:trainhero/src/features/login/presentation/login_screen.dart';
import 'package:trainhero/src/features/ticket_flow/presentation/flexible_ticket_screen.dart';
import 'package:trainhero/src/features/ticket_flow/presentation/flexible_ticket_similar_times_screen.dart';
import 'package:trainhero/src/features/home/presentation/home_screen.dart';
import 'package:trainhero/src/features/landing/presentation/landing_screen.dart';
import 'package:trainhero/src/features/ticket_flow/presentation/loading_ticket_screen.dart';
import 'package:trainhero/src/features/mail/presentation/mail_screen.dart';
import 'package:trainhero/src/features/message/presentation/message_screen.dart';
import 'package:trainhero/src/features/settings/presentation/settings_screen.dart';
import 'package:trainhero/src/features/ticket_flow/presentation/success_screen.dart';
import 'package:trainhero/src/features/ticket_flow/presentation/ticket_summary/ticket_summary_screen.dart';
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
  flexibleTicket,
  flexibleTicketTimes,
  login,
  success,
  ticketSummary,
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
      GoRoute(
        path: '/flexibleTicket',
        name: AppRoute.flexibleTicket.name,
        builder: (context, state) => FlexibleTicketScreen(),
      ),
      GoRoute(
        path: '/flexibleTicketTimes',
        name: AppRoute.flexibleTicketTimes.name,
        builder: (context, state) => const FlexibleTicketSimilarTimesScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/success',
        name: AppRoute.success.name,
        builder: (context, state) => const SuccessScreen(),
      ),
      GoRoute(
        path:
            '/ticketSummary/:origin/:originString/:dest/:destString/:validFrom/:depTime/:returnTkt/:delay/:comp',
        name: AppRoute.ticketSummary.name,
        builder: (context, state) => TicketSummaryScreen(
          origin: state.pathParameters['origin'] ?? '',
          originString: state.pathParameters['originString'] ?? '',
          dest: state.pathParameters['dest'] ?? '',
          destString: state.pathParameters['destString'] ?? '',
          validFrom: state.pathParameters['validFrom'] ?? '',
          depTime: state.pathParameters['depTime'] ?? '',
          returnTkt: int.parse(state.pathParameters['returnTkt'] ?? '0'),
          delay: int.parse(state.pathParameters['delay'] ?? '0'),
          comp: double.parse(state.pathParameters['comp'] ?? '0'),
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
