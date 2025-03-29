import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final token = await SecureStorage.read(StorageConstant.token);

    if (token == null) {
      context.go(AppRoutes.loginPage);
      return;
    }
    if (JwtDecoder.isExpired(token)) {
      await SecureStorage.delete("token");
      CustomMessage.show(
        context,
        message: "Token is expired. Please login again.",
        backgroundColor: Colors.red,
      );
      context.go(AppRoutes.loginPage);
      return;
    }
    final decodedToken = JwtDecoder.decode(token);
    final role = decodedToken['role'];

    if (role == "admin" || role == "org") {
      context.go(AppRoutes.dashboardPage);
    } else {
      CustomMessage.show(
        context,
        message: "You don't have access to this application.",
        backgroundColor: Colors.red,
      );
      await SecureStorage.delete("token");
      context.go(AppRoutes.loginPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          AppLoader(),
        ],
      ),
    );
  }
}
