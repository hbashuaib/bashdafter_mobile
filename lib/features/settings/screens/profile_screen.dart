import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profile;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final data = await ProfileService().getProfile();

      if (!mounted) return;

      setState(() {
        profile = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load profile')));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),

        body: const Center(child: Text('No profile found')),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final firstName = profile!['first_name']?.toString() ?? '';
    final lastName = profile!['last_name']?.toString() ?? '';
    final fullName = '$firstName $lastName'.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

        children: [
          Card(
            color: Colors.blue.shade50,

            child: const Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                children: [
                  Text(
                    'Profile Information',

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 6),

                  Text('Application and user details'),
                ],
              ),
            ),
          ),

          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,

                  child: const Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.white,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,

                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue,

                    child: IconButton(
                      padding: EdgeInsets.zero,

                      icon: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),

                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Profile picture feature coming soon',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            fullName.isEmpty ? profile!['username'] : fullName,
            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            profile!['role']?.toString() ?? 'User',
            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('User'),
              subtitle: Text(
                fullName.isEmpty ? profile!['username'] : fullName,
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.store, color: Colors.green),
              title: const Text('Application'),
              subtitle: const Text('BashDafter'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.orange),
              title: const Text('Role'),
              subtitle: Text(profile!['role']?.toString() ?? 'User'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.alternate_email, color: Colors.cyan),
              title: const Text('Username'),
              subtitle: Text(profile!['username']?.toString() ?? ''),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text('Email'),

              subtitle: Text(
                (profile!['email']?.toString().trim().isNotEmpty ?? false)
                    ? profile!['email'].toString()
                    : '-',
              ),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.color_lens, color: Colors.purple),
              title: const Text('Theme'),
              subtitle: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.teal),
              title: const Text('Version'),
              subtitle: const Text('1.0.0'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.indigo),
              title: const Text('Company'),
              subtitle: const Text('BashSoft Digital'),
            ),
          ),
        ],
      ),
    );
  }
}
