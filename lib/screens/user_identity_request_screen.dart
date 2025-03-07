import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/components/not_found_widget.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/status_helper.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UserIdentityRequestPage extends StatefulWidget {
  final String requestId;
  // final TextEditingController _reasonController = TextEditingController();
  const UserIdentityRequestPage({super.key, required this.requestId});

  @override
  State<UserIdentityRequestPage> createState() =>
      _UserIdentityRequestPageState();
}

class _UserIdentityRequestPageState extends State<UserIdentityRequestPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<IdentityRequestProvider>()
          .fetchRequestById(widget.requestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    IdentityRequestProvider requestProvider =
        context.watch<IdentityRequestProvider>();
    return Scaffold(
      appBar: CustomAppBar(title: "User Identity Request"),
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          Center(
            child: requestProvider.isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : requestProvider.request == null
                    ? NotFoundWidget(text: "User Identity Request not found")
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
                            child: ListView(
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                CircleAvatar(
                                  radius: 53,
                                  backgroundColor: AppColors.primary,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColors.primary,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          requestProvider.request!.profileImage,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 50,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.account_circle,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(requestProvider.request!.fullName,
                                    style: AppTextStyles.poppinsBoldStyle
                                        .copyWith(
                                            fontSize: 24,
                                            color: AppColors.primary)),
                                const SizedBox(height: 10),
                                const Divider(
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.cake, "Date of Birth",
                                    requestProvider.request!.dateOfBirth),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.person, "Gender",
                                    requestProvider.request!.gender),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.flag, "Nationality",
                                    requestProvider.request!.nationality),
                                const SizedBox(height: 10),
                                _buildDetailRow(
                                    Icons.location_on,
                                    "Place of Birth",
                                    requestProvider.request!.placeOfBirth),
                                const SizedBox(height: 10),
                                _buildDetailRow(
                                    Icons.home,
                                    "Address",
                                    requestProvider
                                        .request!.residentialAddress),
                                const SizedBox(height: 10),
                                _buildDetailRow(
                                    Icons.fingerprint,
                                    "Biometric Hash",
                                    requestProvider.request!.biometricHash),
                                const SizedBox(height: 10),
                                _buildDetailRow(Icons.info, "Reason",
                                    requestProvider.request!.reason),
                                if (requestProvider.request!.status ==
                                        StatusHelper.getValue(
                                            Status.rejected) &&
                                    requestProvider
                                        .request!.responseReason!.isNotEmpty)
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      const Divider(
                                        color: AppColors.secondary,
                                      ),
                                      const SizedBox(height: 10),
                                      _buildDetailRow(
                                          Icons.info,
                                          "Response Reason",
                                          requestProvider
                                              .request!.responseReason!),
                                    ],
                                  ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await requestProvider.updateRequest(
                                            requestProvider.request!.id!, {
                                          "status": StatusHelper.getValue(
                                              Status.approved)
                                        });
                                        if (!context.mounted) return;
                                        CustomMessage.show(context,
                                            message: "Request Approved",
                                            backgroundColor: Colors.green);
                                        Navigator.pop(context);
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
                                        final TextEditingController
                                            reasonController =
                                            TextEditingController();

                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Reason for Rejection",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CustomTextField(
                                                      hintText:
                                                          "Provide a reason for rejection",
                                                      icon: Icons
                                                          .highlight_off_outlined,
                                                      label: "Reason",
                                                      controller:
                                                          reasonController,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    if (reasonController.text
                                                        .trim()
                                                        .isEmpty) {
                                                      CustomMessage.show(
                                                        context,
                                                        message:
                                                            "Please provide a reason for rejection.",
                                                        backgroundColor:
                                                            Colors.orange,
                                                      );
                                                      return;
                                                    }

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Send",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        // Check if a reason was provided
                                        if (reasonController.text
                                            .trim()
                                            .isNotEmpty) {
                                          await requestProvider.updateRequest(
                                              requestProvider.request!.id!, {
                                            "status": StatusHelper.getValue(
                                                Status.rejected),
                                            "responseReason":
                                                reasonController.text,
                                          });

                                          if (!context.mounted) return;

                                          CustomMessage.show(
                                            context,
                                            message: "Request Rejected",
                                            backgroundColor: Colors.red,
                                          );

                                          Navigator.pop(context);
                                        } else {
                                          if (!context.mounted) return;
                                          CustomMessage.show(
                                            context,
                                            message:
                                                "Rejection reason is required.",
                                            backgroundColor: Colors.orange,
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
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
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.poppinsRegularStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.poppinsRegularStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
