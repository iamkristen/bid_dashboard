import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/not_found_widget.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/status_helper.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewIdentityRequestPage extends StatelessWidget {
  const ViewIdentityRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<IdentityRequestProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "View All Identity Requests"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: requestProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : requestProvider.error != null
                ? Center(child: Text(requestProvider.error!))
                : requestProvider.requests.isEmpty
                    ? NotFoundWidget(
                        text: "No Identity Request Found",
                      )
                    : ListView.builder(
                        itemCount: requestProvider.requests.length,
                        itemBuilder: (context, index) {
                          final request = requestProvider.requests[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListTile(
                              tileColor: request.status ==
                                      StatusHelper.getValue(Status.pending)
                                  ? Colors.yellow
                                  : request.status ==
                                          StatusHelper.getValue(Status.approved)
                                      ? Colors.green
                                      : Colors.red,
                              leading: CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColors.primary,
                                child: CachedNetworkImage(
                                  imageUrl: request.profileImage,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 50,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.account_circle,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(request.fullName,
                                  style: AppTextStyles.poppinsRegularStyle
                                      .copyWith(color: AppColors.primary)),
                              subtitle: Text(
                                "Action: ${request.action} | Status: ${request.status}",
                                style: AppTextStyles.poppinsRegularStyle
                                    .copyWith(
                                        fontSize: 12, color: AppColors.primary),
                              ),
                              onTap: () => context.go(
                                "${AppRoutes.userIdentityRequestPage}${request.id}",
                                extra: request,
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
