import 'package:dashboard/components/app_loader.dart';
import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/helper/secure_storage.dart';
import 'package:dashboard/helper/storage_constant.dart';
import 'package:dashboard/models/profile_model.dart';
import 'package:dashboard/provider/access_request_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userEmail = await SecureStorage.read(StorageConstant.email);
      Provider.of<AccessRequestProvider>(context, listen: false)
          .fetchRequestByEmail(userEmail!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessRequestProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Stack(
            children: [
              Lottie.asset('lottie/background.json', fit: BoxFit.cover),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Update Your Profile",
                        style: AppTextStyles.icebergStyle.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: InkWell(
                                onTap: provider.pickImage,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  radius: 54,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: provider.avatarBytes != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Image.memory(
                                              provider.avatarBytes!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : provider.request != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                    provider.request!.logo),
                                              )
                                            : const Icon(
                                                Icons.person,
                                                size: 50,
                                                color: AppColors.primary,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              label: "Email",
                              hintText: "xyzcomapny@mail.com",
                              icon: Icons.email_outlined,
                              controller: provider.emailController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: "Organization Name",
                              hintText: "XYZ global organization",
                              icon: Icons.business_outlined,
                              controller: provider.organizationNameController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: "CRN Number",
                              hintText: "123456789",
                              icon: Icons.confirmation_number_outlined,
                              controller: provider.crnNumberController,
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              label: "Reason",
                              hintText: "Why you're updating",
                              icon: Icons.info_outline,
                              controller: provider.reasonController,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (provider.supportingDocuments.length >= 5) {
                                  CustomMessage.show(
                                    context,
                                    message:
                                        "You can only upload up to 5 documents.",
                                    backgroundColor: Colors.red,
                                  );
                                } else {
                                  provider.pickSupportingDocuments();
                                }
                              },
                              icon: const Icon(Icons.upload_file,
                                  color: AppColors.primary),
                              label: Text(
                                "Upload Files",
                                style: AppTextStyles.poppinsRegularStyle
                                    .copyWith(color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (provider.request != null)
                              Column(
                                children:
                                    provider.request!.supportingDocuments.map(
                                  (file) {
                                    final filename =
                                        file.split("/").last.split("-").last;
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
                            Column(
                              children: provider.supportingDocuments
                                  .map(
                                    (file) => ListTile(
                                      leading: const Icon(Icons.file_present),
                                      title: Text(file["fileName"]),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            provider.removeDocument(file),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: CustomButton(
                                text: "Update Profile",
                                onPressed: () async {
                                  try {
                                    final provider =
                                        Provider.of<AccessRequestProvider>(
                                            context,
                                            listen: false);

                                    String logo = provider.request?.logo ?? "";
                                    List<String> urls =
                                        provider.request?.supportingDocuments ??
                                            [];

                                    if (provider.avatarBytes != null) {
                                      final data = await provider.uploadServices
                                          .uploadSingleFile(
                                        provider.fileName,
                                        provider.avatarBytes!,
                                        provider.mimeType,
                                      );
                                      logo = data["url"];
                                    }

                                    if (provider
                                        .supportingDocuments.isNotEmpty) {
                                      final documents = await provider
                                          .uploadServices
                                          .uploadMultipleFiles(
                                              provider.supportingDocuments);
                                      urls =
                                          (documents!["urls"] as List<dynamic>)
                                              .cast<String>();
                                    }

                                    final updatedProfile = ProfileModel(
                                      logo: logo,
                                      name: provider
                                          .organizationNameController.text
                                          .trim(),
                                      crnNumber: provider
                                          .crnNumberController.text
                                          .trim(),
                                      email:
                                          provider.emailController.text.trim(),
                                      reason:
                                          provider.reasonController.text.trim(),
                                      supportingDocuments: urls,
                                    );

                                    await provider.updateRequest(
                                        provider.request!.id!,
                                        updatedProfile.toJson());

                                    if (!context.mounted) return;
                                    context.go(AppRoutes.profileSettingsPage);
                                    CustomMessage.show(
                                      context,
                                      message: "Profile updated successfully",
                                      backgroundColor: Colors.green,
                                    );
                                  } catch (e) {
                                    CustomMessage.show(
                                      context,
                                      message:
                                          removeExceptionPrefix(e.toString()),
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.isLoading) const AppLoader(),
            ],
          ),
        );
      },
    );
  }
}
