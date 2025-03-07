import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/not_found_widget.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/models/registered_user_model.dart';
import 'package:dashboard/provider/registered_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllRegisteredUser extends StatelessWidget {
  const ViewAllRegisteredUser({super.key});

  @override
  Widget build(BuildContext context) {
    final registeredUser = Provider.of<RegisteredUserProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = 250.0; // Width of each card
    final crossAxisCount =
        (screenWidth / cardWidth).floor(); // Calculate number of cards per row

    return Scaffold(
      appBar: const CustomAppBar(title: "View All Registered Users"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: registeredUser.isLoading
            ? const Center(child: CircularProgressIndicator())
            : registeredUser.error != null
                ? Center(child: Text(registeredUser.error!))
                : registeredUser.userData.isEmpty
                    ? const NotFoundWidget(text: "No Registered Users Found")
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 15,
                            runSpacing: 15,
                            children: registeredUser.userData.map((user) {
                              return SizedBox(
                                height: 220,
                                width: constraints.maxWidth / crossAxisCount,
                                child: GestureDetector(
                                  onTap: () {
                                    _showUserPopup(context, user);
                                  },
                                  child: Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
                                              imageUrl: user.url,
                                              height: 130,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                height: 130,
                                                color: Colors.grey.shade300,
                                                child: const Icon(Icons.error,
                                                    size: 50,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            user.id,
                                            style: AppTextStyles.icebergStyle
                                                .copyWith(
                                                    fontSize: 18,
                                                    color: AppColors.primary),
                                          ),
                                          Text(
                                            user.name,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles
                                                .poppinsRegularStyle
                                                .copyWith(
                                                    fontSize: 16,
                                                    color: AppColors.primary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
      ),
    );
  }

  void _showUserPopup(BuildContext context, RegisteredUserData user) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.height * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: user.url,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child:
                          const Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // User ID
                Text(
                  user.id,
                  style: AppTextStyles.icebergStyle
                      .copyWith(fontSize: 18, color: AppColors.primary),
                ),

                // User Name
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.poppinsRegularStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Close",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
