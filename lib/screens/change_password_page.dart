import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/provider/auth_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
  bool isVisibleOldPass = false;
  bool isVisibleNewPass = false;
  bool isVisibleConfirmPass = false;
  void handleChangePassword() async {
    try {
      final current = currentPasswordController.text.trim();
      final newPass = newPasswordController.text.trim();
      final confirm = confirmPasswordController.text.trim();

      if (newPass != confirm) {
        CustomMessage.show(context,
            message: "New password and confirm password do not match",
            backgroundColor: Colors.red);

        return;
      }

      setState(() {
        isLoading = true;
      });
      String id = await SecureStorage.read(StorageConstant.userId) ?? "0";
      await Provider.of<AuthProvider>(context, listen: false).changePassword(
        id: id,
        current: current,
        newPass: newPass,
      );
      context.go(AppRoutes.profileSettingsPage);
      CustomMessage.show(
        context,
        message: "Password changed successfully",
        backgroundColor: Colors.green,
      );
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      isVisibleOldPass = false;
      isVisibleNewPass = false;
      isVisibleConfirmPass = false;
    } catch (e) {
      CustomMessage.show(context,
          message: removeExceptionPrefix(e.toString()),
          backgroundColor: Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                    obscureText: isVisibleOldPass,
                    suffix: IconButton(
                      icon: Icon(
                        isVisibleOldPass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isVisibleOldPass = !isVisibleOldPass;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: newPasswordController,
                    hintText: "New Password",
                    label: "New Password",
                    icon: Icons.lock_open,
                    obscureText: isVisibleNewPass,
                    suffix: IconButton(
                      icon: Icon(
                        isVisibleNewPass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isVisibleNewPass = !isVisibleNewPass;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    label: "Confirm Password",
                    icon: Icons.lock,
                    obscureText: isVisibleConfirmPass,
                    suffix: IconButton(
                      icon: Icon(
                        isVisibleConfirmPass
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          isVisibleConfirmPass = !isVisibleConfirmPass;
                        });
                      },
                    ),
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
