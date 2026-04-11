import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agricare/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green[100],
              child: Icon(Icons.person, size: 50, color: Colors.green[700]),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Information',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Email', user?.email ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildInfoRow('User ID', user?.uid.substring(0, 12) ?? 'N/A'),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Account Created',
                      user?.metadata.creationTime?.toString().split('.')[0] ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
