import 'package:dashboard/components/custom_appbar.dart';
import 'package:dashboard/provider/identity_request_provider.dart';
import 'package:dashboard/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewAllRequestPage extends StatelessWidget {
  const ViewAllRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<IdentityRequestProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "View All Identity Requests"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: requestProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : requestProvider.error != null
                ? Center(child: Text(requestProvider.error!))
                : requestProvider.requests.isEmpty
                    ? const Center(child: Text("No requests found"))
                    : ListView.builder(
                        itemCount: requestProvider.requests.length,
                        itemBuilder: (context, index) {
                          final request = requestProvider.requests[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListTile(
                              tileColor: request.status == "pending"
                                  ? Colors.yellow[100]
                                  : request.status == "approved"
                                      ? Colors.green[100]
                                      : Colors.red[100],
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(request.profileImage),
                              ),
                              title: Text(request.fullName),
                              subtitle: Text(
                                  "Action: ${request.action} | Status: ${request.status}"),
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.viewAllRequestPage,
                                arguments: request,
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
