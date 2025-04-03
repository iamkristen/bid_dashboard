import 'package:dashboard/components/custom_buttons.dart';
import 'package:dashboard/components/side_menu.dart';
import 'package:dashboard/helper/app_colors.dart';
import 'package:dashboard/models/aid_distribution_model.dart';
import 'package:dashboard/provider/aid_distribution_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/helper/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:dashboard/routes.dart';

class ViewAllAidsPage extends StatefulWidget {
  const ViewAllAidsPage({super.key});

  @override
  State<ViewAllAidsPage> createState() => _ViewAllAidsPageState();
}

class _ViewAllAidsPageState extends State<ViewAllAidsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AidDistributionProvider>(context, listen: false)
          .fetchAllAidDistributions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Aid Distribution"),
      drawer: const SideMenu(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomButton(
                icon: Icons.add,
                text: "Add Aid",
                onPressed: () {
                  context.go(AppRoutes.addAids);
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<AidDistributionProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.aidList.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("lottie/no_found.json",
                          width: MediaQuery.of(context).size.width * 0.35),
                      Text(
                        "No Aid Found",
                        style:
                            AppTextStyles.icebergStyle.copyWith(fontSize: 28),
                      ),
                    ],
                  ));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.aidList.length,
                  itemBuilder: (context, index) {
                    final aid = provider.aidList[index];
                    return AidCard(aid: aid);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AidCard extends StatelessWidget {
  final AidDistributionModel aid;

  const AidCard({super.key, required this.aid});

  String _getImageForAidType(String aidType) {
    switch (aidType.toLowerCase()) {
      case 'food':
        return 'images/food.png';
      case 'medicine':
        return 'images/medicine.png';
      case 'cash':
        return 'images/cash.png';
      case 'clothing':
        return 'images/cloth.png';
      case 'shelter':
        return 'images/shelter.png';
      default:
        return 'images/gift.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _getImageForAidType(aid.aidType);
    final expireDate = aid.expire != null
        ? DateFormat('dd MMM yyyy').format(aid.expire!)
        : "N/A";

    final provider =
        Provider.of<AidDistributionProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: 180,
              height: 180,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Aid Type: ${aid.aidType}",
                      style: AppTextStyles.icebergStyle
                          .copyWith(fontSize: 18, color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text("Quantity: ${aid.quantity} ${aid.unit}",
                      style: AppTextStyles.poppinsRegularStyle
                          .copyWith(color: AppColors.primary, fontSize: 14)),
                  Text("Distributed By: ${aid.distributedBy}",
                      style: AppTextStyles.poppinsRegularStyle
                          .copyWith(color: AppColors.primary, fontSize: 14)),
                  Text("Location: ${aid.location}",
                      style: AppTextStyles.poppinsRegularStyle
                          .copyWith(color: AppColors.primary, fontSize: 14)),
                  Text("Expiry Date: $expireDate",
                      style: AppTextStyles.poppinsRegularStyle
                          .copyWith(color: AppColors.primary, fontSize: 14)),
                  if (aid.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Notes: ${aid.notes}",
                        style: AppTextStyles.poppinsRegularStyle
                            .copyWith(color: Colors.red, fontSize: 14),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    icon: Icons.edit,
                    text: "Edit",
                    onPressed: () {
                      context.go("${AppRoutes.editAids}${aid.id}", extra: aid);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    icon: Icons.delete_outline,
                    text: "Delete",
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Confirm Delete"),
                          content: const Text(
                              "Are you sure you want to delete this aid?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await provider.deleteAidDistribution(aid.id!);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
