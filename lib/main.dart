import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/provider/auth_provider.dart';
import 'package:dashboard/provider/event_provider.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:dashboard/provider/registered_user_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:dashboard/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.getInstance();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
        create: (_) => IdentityRequestProvider()..fetchAllRequests()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => AccessRequestProvider()),
    ChangeNotifierProvider(
        create: (_) => RegisteredUserProvider()..fetchAllRequests()),
    ChangeNotifierProvider(create: (_) => EventProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.secondary,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: AppTextStyles.icebergStyle.copyWith(fontSize: 28),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      localizationsDelegates: const [
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      routerConfig: appRouter,
    );
  }
}
