import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/models/aid_distribution_model.dart';
import 'package:dashboard/models/event_models.dart';
import 'package:dashboard/screens/add_edit_aids.dart';
import 'package:dashboard/screens/add_edit_event_page.dart';
import 'package:dashboard/screens/change_password_page.dart';
import 'package:dashboard/screens/profile_page.dart';
import 'package:dashboard/screens/profile_settings_page.dart';
import 'package:dashboard/screens/splash_screen.dart';
import 'package:dashboard/screens/update_profile.dart';
import 'package:dashboard/screens/view_all_access_request_page.dart';
import 'package:dashboard/screens/dashboard_screen.dart';
import 'package:dashboard/screens/login_screen.dart';
import 'package:dashboard/screens/signup_screen.dart';
import 'package:dashboard/screens/user_access_request_page.dart';
import 'package:dashboard/screens/user_identity_request_screen.dart';
import 'package:dashboard/screens/view_all_aids.dart';
import 'package:dashboard/screens/view_all_events.dart';
import 'package:dashboard/screens/view_all_identity_request_screen.dart';
import 'package:dashboard/screens/view_all_registered_user.dart';
import 'package:dashboard/screens/view_event_by_id.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String dashboardPage = '/';
  static const String splashScreen = '/splashScreen';
  static const String viewIdentityRequestPage = '/identityRequest';
  static const String viewAccessRequestPage = '/accessRequest';
  static const String viewAllRegisteredUser = '/viewRegisteredUser';
  static const String signupPage = '/signup';
  static const String loginPage = '/login';
  static const String changePasswordPage = '/changePassword';
  static const String profilePage = '/profile';
  static const String profileSettingsPage = '/profileSettings';
  static const String updateProfile = '/updateProfile';
  static const String eventsPage = '/eventsPage';
  static const String addEventPage = '/addEvent';
  static const String viewAllAids = '/viewAllAids';
  static const String editEventPage = '/editEvent/';
  static const String userIdentityRequestPage = '/userIdentityRequest/';
  static const String userAccessRequestPage = '/userAccessRequest/';
  static const String eventByIdPage = '/eventByIdPage/';
  static const String addAids = '/addAids';
  static const String editAids = '/editAids/';
}

Future<bool> isAuthenticated() async {
  return await SecureStorage.read(StorageConstant.token) != null;
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splashScreen,
  routes: [
    GoRoute(
        path: AppRoutes.splashScreen,
        builder: (context, state) {
          return const SplashScreen();
        }),
    GoRoute(
      path: AppRoutes.dashboardPage,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
        path: AppRoutes.profilePage,
        builder: (context, state) {
          return const ProfilePage();
        }),
    GoRoute(
        path: AppRoutes.profileSettingsPage,
        builder: (context, state) {
          return const ProfileSettingsPage();
        }),
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
        path: AppRoutes.changePasswordPage,
        builder: (context, state) {
          return ChangePasswordPage();
        }),
    GoRoute(
        path: AppRoutes.updateProfile,
        builder: (context, state) {
          return const ProfileUpdatePage();
        }),
    GoRoute(
        path: AppRoutes.viewAllAids,
        builder: (context, state) {
          return ViewAllAidsPage();
        }),
    GoRoute(
        path: AppRoutes.addAids,
        builder: (context, state) {
          return AddOrEditAidPage();
        }),
    GoRoute(
        path: "${AppRoutes.editAids}:aidId",
        builder: (context, state) {
          final extra = state.extra;
          if (extra is AidDistributionModel) {
            return AddOrEditAidPage(aid: extra);
          }
          return const ViewAllAidsPage();
        }),
    GoRoute(
        path: AppRoutes.eventsPage,
        builder: (context, state) {
          return UserEventsPage();
        }),
    GoRoute(
      path: AppRoutes.addEventPage,
      builder: (context, state) => const AddOrEditEventPage(),
    ),
    GoRoute(
      path: "${AppRoutes.editEventPage}:eventId",
      builder: (context, state) {
        final EventModel event = state.extra as EventModel;
        return AddOrEditEventPage(event: event);
      },
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
    GoRoute(
      path: "${AppRoutes.eventByIdPage}:eventId",
      builder: (context, state) {
        final eventId = state.pathParameters['eventId'];
        return ViewEventByIdPage(eventId: eventId ?? "");
      },
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await isAuthenticated();
    final isLoggingInOrSignup = state.uri.toString() == AppRoutes.loginPage ||
        state.uri.toString() == AppRoutes.signupPage;
    if (!isLoggedIn && !isLoggingInOrSignup) {
      return AppRoutes.loginPage;
    }
    if (isLoggedIn && isLoggingInOrSignup) {
      return AppRoutes.dashboardPage;
    }
    return null;
  },
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri.path}'),
      ),
    ),
  ),
);
