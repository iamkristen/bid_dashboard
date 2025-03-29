import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  void handleChangePassword() {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (newPass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("New passwords do not match")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      CustomMessage.show(context,
          message: "Password changed successfully",
          backgroundColor: Colors.green);

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Change Password"),
      body: Stack(
        children: [
          Lottie.asset(
            "lottie/background.json",
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: currentPasswordController,
                    hintText: "Current Password",
                    label: "Current Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: newPasswordController,
                    hintText: "New Password",
                    label: "New Password",
                    icon: Icons.lock_open,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    label: "Confirm Password",
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: CustomButton(
                      text: "Update Password",
                      icon: Icons.save,
                      onPressed: handleChangePassword,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading) const AppLoader(),
        ],
      ),
    );
  }
}
