import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/models/identity_request_model.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class UserRequestPage extends StatelessWidget {
  final IdentityRequest userData;

  const UserRequestPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    IdentityRequestProvider requestProvider =
        context.watch<IdentityRequestProvider>();
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
                width: MediaQuery.of(context).size.width * 0.4,
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
                            imageUrl: userData.profileImage,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 50,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.account_circle,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(userData.fullName,
                          style: AppFonts.poppinsBoldStyle.copyWith(
                              fontSize: 24, color: AppColors.primary)),
                      const SizedBox(height: 10),
                      const Divider(
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          Icons.cake, "Date of Birth", userData.dateOfBirth),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.person, "Gender", userData.gender),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          Icons.flag, "Nationality", userData.nationality),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.location_on, "Place of Birth",
                          userData.placeOfBirth),
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          Icons.home, "Address", userData.residentialAddress),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.fingerprint, "Biometric Hash",
                          userData.biometricHash),
                      const SizedBox(height: 10),
                      _buildDetailRow(Icons.info, "Reason", userData.reason),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              await requestProvider.updateRequest(
                                  userData.id, {"status": "approved"});
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Request Approved")),
                              );
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check, color: Colors.white),
                            label: const Text(
                              "Approve",
                              style: AppFonts.poppinsRegularStyle,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await requestProvider.updateRequest(
                                  userData.id, {"status": "rejected"});
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Request Rejected")),
                              );
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Reject",
                              style: AppFonts.poppinsRegularStyle,
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
                style: AppFonts.poppinsRegularStyle.copyWith(
                  fontSize: 16,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppFonts.poppinsRegularStyle.copyWith(
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
