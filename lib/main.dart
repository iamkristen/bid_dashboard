import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => IdentityRequestProvider()..fetchAllRequests()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.secondary,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: AppFonts.icebergStyle.copyWith(fontSize: 28),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          )),
      initialRoute: AppRoutes.viewAllRequestPage,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
