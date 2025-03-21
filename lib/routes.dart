import 'package:dashboard/screens/view_all_access_request_page.dart';
import 'package:dashboard/screens/dashboard_screen.dart';
import 'package:dashboard/screens/login_screen.dart';
import 'package:dashboard/screens/signup_screen.dart';
import 'package:dashboard/screens/user_access_request_page.dart';
import 'package:dashboard/screens/user_identity_request_screen.dart';
import 'package:dashboard/screens/view_all_identity_request_screen.dart';
import 'package:dashboard/screens/view_all_registered_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String dashboardPage = '/';
  static const String viewIdentityRequestPage = '/identityRequest';
  static const String viewAccessRequestPage = '/accessRequest';
  static const String viewAllRegisteredUser = '/viewRegisteredUser';
  static const String signupPage = '/signup';
  static const String loginPage = '/login';
  static const String userIdentityRequestPage = '/userIdentityRequest/';
  static const String userAccessRequestPage = '/userAccessRequest/';
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.dashboardPage,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: AppRoutes.viewAllRegisteredUser,
      builder: (context, state) => const ViewAllRegisteredUser(),
    ),
    GoRoute(
      path: AppRoutes.viewIdentityRequestPage,
      builder: (context, state) => const ViewIdentityRequestPage(),
    ),
    GoRoute(
      path: AppRoutes.viewAccessRequestPage,
      builder: (context, state) => const ViewAccessRequestPage(),
    ),
    GoRoute(
      path: AppRoutes.signupPage,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.loginPage,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "${AppRoutes.userIdentityRequestPage}:userId",
      builder: (context, state) {
        final userId = state.pathParameters['userId'];
        return UserIdentityRequestPage(
          requestId: userId ?? "",
        );
      },
    ),
    GoRoute(
      path: "${AppRoutes.userAccessRequestPage}:accessId",
      builder: (context, state) {
        final accessId = state.pathParameters['accessId'];
        // final accessData = state.extra as AccessRequestModel;
        return UserAccessRequestPage(userId: accessId ?? "");
      },
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri.path}'),
      ),
    ),
  ),
);
