import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:flutter/material.dart';
import '../routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Image.asset(
              "logo.png",
            ),
          ),
          ListTile(
            title: Text(
              "Dashboard",
              style: AppTextStyles.poppinsRegularStyle
                  .copyWith(color: AppColors.primary),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.dashboard);
            },
          ),
          ListTile(
            title: Text(
              "View Identity Requests",
              style: AppTextStyles.poppinsRegularStyle
                  .copyWith(color: AppColors.primary),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.viewIdentityRequestPage);
            },
          ),
          ListTile(
            title: Text(
              "View Access Requests ",
              style: AppTextStyles.poppinsRegularStyle
                  .copyWith(color: AppColors.primary),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.viewAccessRequestPage);
            },
          ),
        ],
      ),
    );
  }
}
