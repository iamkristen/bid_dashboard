import 'package:dashboard/models/access_request_model.dart';
import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/screens/access_request_page.dart';
import 'package:dashboard/screens/dashboard_screen.dart';
import 'package:dashboard/screens/login_screen.dart';
import 'package:dashboard/screens/signup_screen.dart';
import 'package:dashboard/screens/user_access_request_page.dart';
import 'package:dashboard/screens/user_request_screen.dart';
import 'package:dashboard/screens/view_all_request_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String viewIdentityRequestPage = '/identityRequest';
  static const String viewAccessRequestPage = '/accessRequest';
  static const String userRequestPage = '/userRequest';
  static const String userAccessRequestPage = '/userAccessRequest';
  static const String signupPage = '/signup';
  static const String loginPage = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      case viewIdentityRequestPage:
        return MaterialPageRoute(builder: (_) => ViewIdentityRequestPage());
      case userRequestPage:
        final userData = settings.arguments as IdentityRequestModel;
        return MaterialPageRoute(
            builder: (_) => UserRequestPage(
                  userData: userData,
                ));
      case userAccessRequestPage:
        final accessData = settings.arguments as AccessRequestModel;
        return MaterialPageRoute(
            builder: (_) => UserAccessRequestPage(
                  userData: accessData,
                ));

      case viewAccessRequestPage:
        return MaterialPageRoute(builder: (_) => ViewAccessRequestPage());
      case signupPage:
        return MaterialPageRoute(builder: (_) => SignupPage());

      case loginPage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
