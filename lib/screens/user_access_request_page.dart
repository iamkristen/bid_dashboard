import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/not_found_widget.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/helper/status_helper.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class UserAccessRequestPage extends StatefulWidget {
  final String userId;

  const UserAccessRequestPage({super.key, required this.userId});

  @override
  State<UserAccessRequestPage> createState() => _UserAccessRequestPageState();
}

class _UserAccessRequestPageState extends State<UserAccessRequestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accessRequestProvider = context.read<AccessRequestProvider>();
      accessRequestProvider.fetchRequestById(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    AccessRequestProvider accessRequestProvider =
        context.watch<AccessRequestProvider>();
    return Scaffold(
      appBar: CustomAppBar(title: "User Access Request"),
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          Center(
            child: accessRequestProvider.isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : accessRequestProvider.request == null
                    ? NotFoundWidget(text: "User Access Not Found")
                    : Card(
                        elevation: 8,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 53,
                                    backgroundColor: AppColors.primary,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: AppColors.primary,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            accessRequestProvider.request!.logo,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 50,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.account_circle,
                                          size: 100,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    accessRequestProvider.request!.name,
                                    style:
                                        AppTextStyles.poppinsBoldStyle.copyWith(
                                      fontSize: 24,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(color: AppColors.secondary),
                                  const SizedBox(height: 10),

                                  // Stylish Table
                                  Table(
                                    columnWidths: const {
                                      0: FixedColumnWidth(150),
                                      1: FlexColumnWidth(),
                                    },
                                    children: [
                                      _buildTableRow("Name",
                                          accessRequestProvider.request!.name),
                                      _buildTableRow("Email",
                                          accessRequestProvider.request!.email),
                                      _buildTableRow(
                                        "CRN",
                                        accessRequestProvider
                                            .request!.crnNumber,
                                      ),
                                      _buildTableRow(
                                          "Reason",
                                          accessRequestProvider
                                              .request!.reason),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  const Text(
                                    "Supporting Documents",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    children: accessRequestProvider
                                        .request!.supportingDocuments
                                        .map(
                                      (file) {
                                        final filename = file
                                            .split("/")
                                            .last
                                            .split("-")
                                            .last;
                                        return Card(
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.file_present,
                                              color: AppColors.primary,
                                            ),
                                            title: Text(
                                              filename,
                                              style: AppTextStyles
                                                  .poppinsRegularStyle
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            onTap: () {
                                              html.window.open(
                                                file,
                                                filename,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ).toList(),
                                  ),

                                  const SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          try {
                                            final res =
                                                await authProvider.signup(
                                              accessRequestProvider
                                                  .request!.email,
                                            );

                                            final updateData =
                                                await accessRequestProvider
                                                    .updateRequest(
                                                        accessRequestProvider
                                                            .request!.id!,
                                                        {
                                                  "status":
                                                      StatusHelper.getValue(
                                                          Status.approved),
                                                });

                                            if (res && updateData) {
                                              if (!context.mounted) return;
                                              CustomMessage.show(context,
                                                  message: "Request Approved",
                                                  backgroundColor:
                                                      Colors.green);
                                            }

                                            Navigator.pop(context);
                                          } catch (e) {
                                            if (!context.mounted) return;

                                            CustomMessage.show(context,
                                                message: removeExceptionPrefix(
                                                    e.toString()),
                                                backgroundColor: Colors.red);
                                          }
                                        },
                                        icon: const Icon(Icons.check,
                                            color: Colors.white),
                                        label: const Text(
                                          "Approve",
                                          style:
                                              AppTextStyles.poppinsRegularStyle,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          try {
                                            final res =
                                                await accessRequestProvider
                                                    .sendRejectionEmail(
                                              email: accessRequestProvider
                                                  .request!.email,
                                              name: accessRequestProvider
                                                  .request!.name,
                                            );
                                            final updateData =
                                                await accessRequestProvider
                                                    .updateRequest(
                                                        accessRequestProvider
                                                            .request!.id!,
                                                        {
                                                  "status":
                                                      StatusHelper.getValue(
                                                          Status.rejected),
                                                });

                                            if (res && updateData) {
                                              if (!context.mounted) return;
                                              CustomMessage.show(context,
                                                  message: "Request Rejected",
                                                  backgroundColor: Colors.red);
                                            }

                                            Navigator.pop(context);
                                          } catch (e) {
                                            if (!context.mounted) return;

                                            CustomMessage.show(context,
                                                message: removeExceptionPrefix(
                                                    e.toString()),
                                                backgroundColor: Colors.red);
                                          }
                                        },
                                        icon: const Icon(Icons.close,
                                            color: Colors.white),
                                        label: const Text(
                                          "Reject",
                                          style:
                                              AppTextStyles.poppinsRegularStyle,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ),
          authProvider.isLoading && accessRequestProvider.isLoading
              ? const AppLoader()
              : const SizedBox(),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: AppTextStyles.poppinsBoldStyle.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            value,
            style: AppTextStyles.poppinsRegularStyle.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
