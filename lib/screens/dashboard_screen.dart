import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/side_menu.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/provider/aid_distribution_provider.dart';
import 'package:dashboard/provider/event_provider.dart';
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
  late String role;
  bool _loading = true;

  setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();
    });
  }

  Future<void> _loadData() async {
    setLoading(true);
    role = await SecureStorage.read(StorageConstant.role) ?? "org";
    final identityProvider =
        Provider.of<IdentityRequestProvider>(context, listen: false);
    final accessProvider =
        Provider.of<AccessRequestProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final aidsProvider =
        Provider.of<AidDistributionProvider>(context, listen: false);

    await identityProvider.getRequestCount();
    await accessProvider.getRequestCount();
    await eventProvider.getEventsCount();
    await aidsProvider.getAllAidsCount();

    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Dashboard",
      ),
      drawer: const SideMenu(),
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: [
                              role == "admin"
                                  ? _buildInfoCard(
                                      context,
                                      title: "Identity Requests",
                                      icon: Image.asset("images/id_card.png",
                                          width: 75),
                                      count:
                                          Provider.of<IdentityRequestProvider>(
                                                  context)
                                              .count,
                                      page: () => context.go(
                                          AppRoutes.viewIdentityRequestPage),
                                    )
                                  : const SizedBox.shrink(),
                              role == "admin"
                                  ? _buildInfoCard(
                                      context,
                                      title: "Access Requests",
                                      icon: Image.asset("images/access.png",
                                          width: 75),
                                      count: Provider.of<AccessRequestProvider>(
                                              context)
                                          .count,
                                      page: () => context
                                          .go(AppRoutes.viewAccessRequestPage),
                                    )
                                  : const SizedBox.shrink(),
                              _buildInfoCard(
                                context,
                                title: "Registered Users",
                                icon: Image.asset("images/user.png", width: 75),
                                count:
                                    Provider.of<RegisteredUserProvider>(context)
                                        .userData
                                        .length,
                                page: () =>
                                    context.go(AppRoutes.viewAllRegisteredUser),
                              ),
                              _buildInfoCard(
                                context,
                                title: "Total Events",
                                icon:
                                    Image.asset("images/events.png", width: 75),
                                count: Provider.of<EventProvider>(context)
                                    .eventCount,
                                page: () => context.go(AppRoutes.eventsPage),
                              ),
                              _buildInfoCard(
                                context,
                                title: "Total Aids",
                                icon: Image.asset("images/aids.png", width: 75),
                                count: Provider.of<AidDistributionProvider>(
                                        context)
                                    .aidCount,
                                page: () => context.go(AppRoutes.viewAllAids),
                              ),
                            ],
                          ),
                          Lottie.asset(
                            "lottie/test.json",
                            width: 300,
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
    return SizedBox(
      width: MediaQuery.of(context).size.width > 900
          ? MediaQuery.of(context).size.width / 4 - 24
          : MediaQuery.of(context).size.width / 3 - 24,
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
