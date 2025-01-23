import 'package:dashboard/screens/dashboard.dart';
import 'package:dashboard/screens/user_request_parge.dart';
import 'package:dashboard/screens/view_all_request_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String dashboard = '/';
  static const String viewAllRequestPage = '/allRequests';
  static const String userRequest = '/userRequest';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      case viewAllRequestPage:
        return MaterialPageRoute(builder: (_) => ViewAllRequestPage());
      case userRequest:
        final userData = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => UserRequestPage(
                  userData: userData,
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
