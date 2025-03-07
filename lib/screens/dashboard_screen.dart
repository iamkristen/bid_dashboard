import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/side_menu.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:dashboard/provider/registered_user_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IdentityRequestProvider>(context, listen: false)
          .getRequestCount();
      Provider.of<AccessRequestProvider>(context, listen: false)
          .getRequestCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Dashboard",
      ),
      drawer: SideMenu(),
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          context,
                          title: "Identity Requests",
                          icon: Image.asset("images/id_card.png", width: 75),
                          count: Provider.of<IdentityRequestProvider>(context)
                              .count,
                          page: () =>
                              context.go(AppRoutes.viewIdentityRequestPage),
                        ),
                        _buildInfoCard(
                          context,
                          title: "Access Requests",
                          icon: Image.asset("images/access.png", width: 75),
                          count:
                              Provider.of<AccessRequestProvider>(context).count,
                          page: () =>
                              context.go(AppRoutes.viewAccessRequestPage),
                        ),
                        _buildInfoCard(
                          context,
                          title: "Registered Users",
                          icon: Image.asset("images/user.png", width: 75),
                          count: Provider.of<RegisteredUserProvider>(context)
                              .userData
                              .length,
                          page: () =>
                              context.go(AppRoutes.viewAllRegisteredUser),
                        ),
                      ],
                    ),
                    Lottie.asset(
                      "lottie/test.json",
                      width: 300,
                      // height: MediaQuery.of(context).size.height * 0.7,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required Widget icon,
    required int count,
    required Function() page,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: page,
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 10),
                Text(
                  title,
                  style: AppTextStyles.icebergStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  count.toString(),
                  style: AppTextStyles.icebergStyle.copyWith(
                    fontSize: 28,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
