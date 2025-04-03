import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/side_menu.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ViewIdentityRequestPage extends StatelessWidget {
  const ViewIdentityRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<IdentityRequestProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 250.0;
    final crossAxisCount = (screenWidth / cardWidth).floor();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const CustomAppBar(title: "View All Identity Requests"),
        drawer: const SideMenu(),
        body: Stack(
          children: [
            Lottie.asset("lottie/background.json", width: 400, height: 400),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: requestProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        // TabBar for filtering
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TabBar(
                                  isScrollable: true,
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: AppColors.light,
                                  labelStyle: AppTextStyles.poppinsRegularStyle
                                      .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dividerColor: Colors.transparent,
                                  onTap: (index) {
                                    final provider =
                                        Provider.of<IdentityRequestProvider>(
                                            context,
                                            listen: false);
                                    if (index == 0) {
                                      provider.setFilterRequests("All");
                                    } else if (index == 1) {
                                      provider.setFilterRequests("Pending");
                                    } else if (index == 2) {
                                      provider.setFilterRequests("Rejected");
                                    } else if (index == 3) {
                                      provider.setFilterRequests("Approved");
                                    }
                                  },
                                  tabs: const [
                                    Tab(text: "All"),
                                    Tab(text: "Pending"),
                                    Tab(text: "Rejected"),
                                    Tab(text: "Approved"),
                                  ],
                                ),
                              ),
                            ),
                            // Pagination controls
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Pages",
                                    style: AppTextStyles.icebergStyle.copyWith(
                                      fontSize: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  for (int i in _getPaginationList(
                                      requestProvider.currentPage,
                                      requestProvider.availablePages))
                                    GestureDetector(
                                      onTap: () async {
                                        if (i != -1) {
                                          await requestProvider
                                              .fetchAllRequests(page: i);
                                        }
                                      },
                                      child: Transform.rotate(
                                        angle: 0.7854, // 45 degrees in radians
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: i ==
                                                    requestProvider.currentPage
                                                ? AppColors
                                                    .primary // Highlight Active Page
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: AppColors.primary),
                                          ),
                                          child: Transform.rotate(
                                            angle:
                                                -0.7854, // Rotate text back to normal
                                            child: Text(
                                              i == -1
                                                  ? "..."
                                                  : i.toString(), // Show '...' for skipped pages
                                              style: AppTextStyles.icebergStyle
                                                  .copyWith(
                                                fontSize: 18,
                                                color: i ==
                                                        requestProvider
                                                            .currentPage
                                                    ? Colors.white
                                                    : AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Filtered List View
                        Expanded(
                          child: requestProvider.filteredRequests.isNotEmpty
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 15,
                                  runSpacing: 15,
                                  children: requestProvider.filteredRequests
                                      .map((request) {
                                    return SizedBox(
                                      height: 220,
                                      width: MediaQuery.of(context).size.width /
                                          crossAxisCount,
                                      child: GestureDetector(
                                        onTap: () => context.go(
                                          "${AppRoutes.userIdentityRequestPage}${request.id}",
                                        ),
                                        child: Card(
                                          elevation: 6,
                                          color: request.status == "Pending"
                                              ? Colors.yellow
                                              : request.status == "Approved"
                                                  ? Colors.green
                                                  : Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        request.profileImage,
                                                    height: 130,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      height: 130,
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                          Icons.account_circle,
                                                          size: 120,
                                                          color: AppColors
                                                              .primary),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  request.fullName,
                                                  style: AppTextStyles
                                                      .icebergStyle
                                                      .copyWith(
                                                          fontSize: 18,
                                                          color: AppColors
                                                              .primary),
                                                ),
                                                Text(
                                                  "Action: ${request.action} | Status: ${request.status}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles
                                                      .poppinsRegularStyle
                                                      .copyWith(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .primary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Center(
                                  child: Text(
                                    "No Identity Requests Found",
                                    style: AppTextStyles.icebergStyle.copyWith(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<int> _getPaginationList(int currentPage, int totalPages) {
    List<int> pages = [];

    if (totalPages <= 7) {
      return List.generate(totalPages, (index) => index + 1);
    }

    pages.add(1);

    if (currentPage > 3) {
      pages.add(-1);
    }

    for (int i = max(2, currentPage - 1);
        i <= min(totalPages - 1, currentPage + 1);
        i++) {
      pages.add(i);
    }

    if (currentPage < totalPages - 2) {
      pages.add(-1);
    }

    pages.add(totalPages);

    return pages;
  }
}
