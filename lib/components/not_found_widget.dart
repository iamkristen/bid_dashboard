import 'package:dashboard/helper/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    super.key,
    required this.text,
    this.fontsize,
  });
  final String text;
  final double? fontsize;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset("lottie/no_found.json",
            width: MediaQuery.of(context).size.width * 0.25),
        Text(
          text,
          style: AppTextStyles.icebergStyle.copyWith(fontSize: fontsize ?? 28),
        ),
      ],
    ));
  }
}
