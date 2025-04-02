import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/side_menu.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile Settings"),
      drawer: const SideMenu(),
      body: Stack(
        children: [
          Lottie.asset(
            "lottie/background.json",
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Manage Your Profile",
                        style: AppTextStyles.icebergStyle
                            .copyWith(fontSize: 24, color: AppColors.primary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildSettingButton(
                        context,
                        title: "Change Password",
                        icon: Icons.lock_outline,
                        onTap: () {
                          context.go(AppRoutes.changePasswordPage);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildSettingButton(
                        context,
                        title: "Update Profile",
                        icon: Icons.edit_outlined,
                        onTap: () {
                          context.go(AppRoutes.updateProfile);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 22),
      label: Text(
        title,
        style: AppTextStyles.poppinsRegularStyle
            .copyWith(fontSize: 16, color: AppColors.primary),
      ),
    );
  }
}
