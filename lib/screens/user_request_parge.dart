import 'package:flutter/material.dart';

class UserRequestPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserRequestPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Identity Request"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData['profileImage'] ?? ''),
                  onBackgroundImageError: (_, __) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Full Name: ${userData['fullName'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Date of Birth: ${userData['dateOfBirth'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Gender: ${userData['gender'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Nationality: ${userData['nationality'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Place of Birth: ${userData['placeOfBirth'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Residential Address: ${userData['residentialAddress'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Biometric Hash: ${userData['biometricHash'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Reason: ${userData['reason'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle approve action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Request Approved")),
                      );
                    },
                    child: const Text("Approve"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle reject action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Request Rejected")),
                      );
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text("Reject"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
