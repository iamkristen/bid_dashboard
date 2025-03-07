import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/loading_dialog.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/helper/status_helper.dart';
import 'package:dashboard/models/access_request_model.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class UserAccessRequestPage extends StatelessWidget {
  final AccessRequestModel userData;

  const UserAccessRequestPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    AccessRequestProvider accessRequestProvider =
        context.watch<AccessRequestProvider>();
    return Scaffold(
      appBar: CustomAppBar(title: "User Request"),
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          Center(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
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
                            imageUrl: userData.logo,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 50,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.account_circle,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userData.name,
                        style: AppTextStyles.poppinsBoldStyle.copyWith(
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
                          _buildTableRow("Name", userData.name),
                          _buildTableRow("Email", userData.email),
                          _buildTableRow(
                            "CRN",
                            userData.crnNumber,
                          ),
                          _buildTableRow("Reason", userData.reason),
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
                        children: userData.supportingDocuments.map(
                          (file) {
                            final filename =
                                file.split("/").last.split("-").last;
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.file_present,
                                  color: AppColors.primary,
                                ),
                                title: Text(
                                  filename,
                                  style: AppTextStyles.poppinsRegularStyle
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                LoadingDialog.show(context,
                                    loadingText: "Approving Request...");
                                final res = await authProvider.signup(
                                  userData.email,
                                );

                                final updateData = await accessRequestProvider
                                    .updateRequest(userData.id!, {
                                  "status":
                                      StatusHelper.getValue(Status.approved),
                                });

                                if (res && updateData) {
                                  if (!context.mounted) return;
                                  CustomMessage.show(context,
                                      message: "Request Approved",
                                      backgroundColor: Colors.green);
                                }
                                LoadingDialog.dismiss(context);
                                Navigator.pop(context);
                              } catch (e) {
                                if (!context.mounted) return;
                                LoadingDialog.dismiss(context);

                                CustomMessage.show(context,
                                    message:
                                        removeExceptionPrefix(e.toString()),
                                    backgroundColor: Colors.red);
                              }
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text(
                              "Approve",
                              style: AppTextStyles.poppinsRegularStyle,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              LoadingDialog.show(context,
                                  loadingText: "Rejecting Request...");
                              try {
                                final res =
                                    await authProvider.sendRejectionEmail(
                                  email: userData.email,
                                  name: userData.name,
                                );
                                final updateData = await accessRequestProvider
                                    .updateRequest(userData.id!, {
                                  "status":
                                      StatusHelper.getValue(Status.rejected),
                                });

                                if (res && updateData) {
                                  if (!context.mounted) return;
                                  CustomMessage.show(context,
                                      message: "Request Rejected",
                                      backgroundColor: Colors.red);
                                }
                                LoadingDialog.dismiss(context);
                                Navigator.pop(context);
                              } catch (e) {
                                if (!context.mounted) return;
                                LoadingDialog.dismiss(context);

                                CustomMessage.show(context,
                                    message:
                                        removeExceptionPrefix(e.toString()),
                                    backgroundColor: Colors.red);
                              }
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                            label: const Text(
                              "Reject",
                              style: AppTextStyles.poppinsRegularStyle,
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

  // Future<void> _showRejectionDialog(
  //     BuildContext context, IdentityRequestProvider requestProvider) async {
  //   final TextEditingController reasonController = TextEditingController();

  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text(
  //           "Reason for Rejection",
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         content: CustomTextField(
  //           hintText: "Provide a reason for rejection",
  //           icon: Icons.highlight_off_outlined,
  //           label: "Reason",
  //           controller: reasonController,
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               if (reasonController.text.trim().isEmpty) {
  //                 CustomMessage.show(
  //                   context,
  //                   message: "Please provide a reason for rejection.",
  //                   backgroundColor: Colors.orange,
  //                 );
  //                 return;
  //               }
  //               Navigator.pop(context, reasonController.text);
  //             },
  //             child: const Text(
  //               "Send",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text(
  //               "Cancel",
  //               style: TextStyle(color: Colors.grey),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (reasonController.text.trim().isNotEmpty) {
  //     await requestProvider.updateRequest(userData.id!, {
  //       "status": "rejected",
  //       "responseReason": reasonController.text,
  //     });

  //     if (!context.mounted) return;

  //     CustomMessage.show(
  //       context,
  //       message: "Request Rejected",
  //       backgroundColor: Colors.red,
  //     );

  //     Navigator.pop(context);
  //   }
  // }
}
