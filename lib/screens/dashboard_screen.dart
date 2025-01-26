import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Dashboard",
      ),
      drawer: SideMenu(),
      body: Stack(
        children: [
          Lottie.asset("lottie/background.json", width: 400, height: 400),
          Center(
            child: Column(
              children: [
                Lottie.asset(
                  "lottie/test.json",
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
