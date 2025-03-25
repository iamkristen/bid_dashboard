import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/custom_message.dart';
import 'package:dashboard/components/custom_textfields.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:dashboard/helper/loading_dialog.dart';
import 'package:dashboard/helper/remove_exception_string.dart';
import 'package:dashboard/provider/auth_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background animation
            Lottie.asset(
              'lottie/background.json',
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.4,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "Request for Access",
                              style: AppTextStyles.icebergStyle.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
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
                            child: SingleChildScrollView(
                              child: Consumer<AuthProvider>(
                                builder: (context, provider, child) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      // Avatar Picker
                                      Center(
                                        child: InkWell(
                                          onTap: provider.pickImage,
                                          child: CircleAvatar(
                                            backgroundColor: AppColors.primary,
                                            radius: 54,
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.white,
                                              child: provider.avatarBytes !=
                                                      null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Image.memory(
                                                        provider.avatarBytes!,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : const Icon(
                                                      Icons.person_add_alt_1,
                                                      size: 50,
                                                      color: AppColors.primary,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      // Form Fields
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
                                        controller:
                                            provider.organizationNameController,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                        label: "CRN Number",
                                        hintText: "123456789",
                                        icon:
                                            Icons.confirmation_number_outlined,
                                        controller:
                                            provider.crnNumberController,
                                      ),
                                      const SizedBox(height: 10),
                                      CustomTextField(
                                        label: "Reason",
                                        hintText: "Reason for access",
                                        icon: Icons.info_outline,
                                        controller: provider.reasonController,
                                      ),
                                      const SizedBox(height: 20),
                                      // Supporting Documents Section
                                      Text(
                                        "Supporting Documents (Max: 5):",
                                        style: AppTextStyles.poppinsRegularStyle
                                            .copyWith(
                                          fontSize: 16,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          if (provider
                                                  .supportingDocuments.length >=
                                              5) {
                                            CustomMessage.show(
                                              context,
                                              message:
                                                  "You can only upload up to 5 supporting documents.",
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
                                          style: AppTextStyles
                                              .poppinsRegularStyle
                                              .copyWith(
                                                  color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Display Uploaded Files
                                      Column(
                                        children: provider.supportingDocuments
                                            .map(
                                              (file) => ListTile(
                                                leading: const Icon(Icons
                                                    .file_present_outlined),
                                                title: Text(file["fileName"]),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    provider
                                                        .removeDocument(file);
                                                  },
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 20),

                                      Center(
                                        child: CustomButton(
                                          text: "Submit Request",
                                          onPressed: () async {
                                            LoadingDialog.show(context,
                                                loadingText:
                                                    "Submitting request...");
                                            try {
                                              await provider.registerProfile();

                                              if (!context.mounted) return;
                                              Navigator.pop(context);
                                              CustomMessage.show(
                                                context,
                                                message:
                                                    "Request submitted successfully",
                                                backgroundColor: Colors.green,
                                              );
                                            } catch (e) {
                                              LoadingDialog.dismiss(context);
                                              CustomMessage.show(
                                                context,
                                                message: removeExceptionPrefix(
                                                    e.toString()),
                                                backgroundColor: Colors.red,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Align(
                                        alignment: Alignment.center,
                                        child: RichText(
                                            text: TextSpan(
                                          text: "Already have an access? ",
                                          style: AppTextStyles
                                              .poppinsRegularStyle
                                              .copyWith(
                                            color: AppColors.primary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Login",
                                              style: AppTextStyles
                                                  .poppinsBoldStyle
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  context
                                                      .go(AppRoutes.loginPage);
                                                },
                                            ),
                                          ],
                                        )),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
