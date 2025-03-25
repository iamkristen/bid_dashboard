import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/provider/auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:dashboard/components/app_loader.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import the AppLoader

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background Animation
            Lottie.asset(
              'lottie/background.json',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
            // Content Container
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                      maxHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "logo.png",
                          width: 175,
                        ),
                        Center(
                          child: Text(
                            "Login to your account",
                            style: AppTextStyles.icebergStyle.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SingleChildScrollView(
                            child: Consumer<AuthProvider>(
                              builder: (context, provider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    CustomTextField(
                                      label: "Email",
                                      hintText: "xyzcomapny@mail.com",
                                      icon: Icons.email_outlined,
                                      controller: provider.emailController,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomTextField(
                                      label: "Password",
                                      hintText: "*********",
                                      icon: Icons.password_outlined,
                                      obscureText: true,
                                      controller: provider.passwordController,
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: CustomButton(
                                        text: "Login",
                                        onPressed: () async {
                                          try {
                                            final token =
                                                await provider.login();

                                            if (!context.mounted) return;

                                            context.go(AppRoutes.dashboardPage);
                                          } catch (e) {
                                            CustomMessage.show(
                                              context,
                                              message: removeExceptionPrefix(
                                                  e.toString()),
                                              backgroundColor: Colors.red,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Don't have an access? ",
                                          style: AppTextStyles
                                              .poppinsRegularStyle
                                              .copyWith(
                                            color: AppColors.primary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Request Access",
                                              style: AppTextStyles
                                                  .poppinsBoldStyle
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  context
                                                      .go(AppRoutes.signupPage);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Show AppLoader if loading is true
            if (Provider.of<AuthProvider>(context).isLoading) const AppLoader(),
          ],
        ),
      ),
    );
  }
}
