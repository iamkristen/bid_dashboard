import 'package:dashboard/components/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import '../routes.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String? role;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final storedRole = await SecureStorage.read(StorageConstant.role);
    if (mounted) {
      setState(() {
        role = storedRole ?? "user";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Drawer(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Image.asset("logo.png"),
            ),
          ),
          _buildMenuItem(
            context,
            title: "Profile",
            onTap: () => context.go(AppRoutes.profilePage),
            trailing: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.go(AppRoutes.profileSettingsPage),
            ),
          ),
          _buildMenuItem(
            context,
            title: "Dashboard",
            onTap: () => context.go(AppRoutes.dashboardPage),
          ),
          if (role == 'admin') ...[
            _buildMenuItem(
              context,
              title: "View Registered Users",
              onTap: () => context.go(AppRoutes.viewAllRegisteredUser),
            ),
            _buildMenuItem(
              context,
              title: "View Identity Requests",
              onTap: () => context.go(AppRoutes.viewIdentityRequestPage),
            ),
            _buildMenuItem(
              context,
              title: "View Access Requests",
              onTap: () => context.go(AppRoutes.viewAccessRequestPage),
            ),
          ],
          _buildMenuItem(
            context,
            title: "View All Events",
            onTap: () => context.go(AppRoutes.eventsPage),
          ),
          _buildMenuItem(
            context,
            title: "View All Aids",
            onTap: () => context.go(AppRoutes.viewAllAids),
          ),
          // const SizedBox(height: 20),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 10,
              bottom: 30,
            ),
            child: CustomButton(
              width: 200,
              icon: Icons.logout,
              text: "Logout",
              onPressed: () {
                SecureStorage.clear();
                context.go(AppRoutes.loginPage);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String title, required VoidCallback onTap, Widget? trailing}) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.poppinsRegularStyle.copyWith(
          color: AppColors.primary,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
