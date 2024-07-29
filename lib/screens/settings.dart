import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kudiaccess/screens/logout.dart';
import 'package:kudiaccess/screens/profile.dart';

import '../providers/color_providers.dart';
import 'chat.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorState = ref.watch(colorProvider);

    return Scaffold(
      backgroundColor: colorState.baseColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.chevron_left_rounded,
                          color: colorState.generatedColors[1]),
                    ),
                    Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 18, color: colorState.generatedColors[1]),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text('Account'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen())),
                        child: CustomListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ProfileScreen())),
                          icon: Icons.person_2_outlined,
                          title: 'Edit Profile',
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      CustomListTile(
                        icon: Icons.security_rounded,
                        title: 'Security',
                        onTap: () {},
                      ),
                      const Divider(color: Colors.grey),
                      CustomListTile(
                        icon: Icons.lock,
                        title: 'Privacy',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Support & About'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      CustomListTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatScreen())),
                      ),
                      const Divider(color: Colors.grey),
                      CustomListTile(
                        icon: Icons.wallet,
                        title: 'Terms and Conditions',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text('Actions'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Column(
                    children: [
                      CustomListTile(
                        icon: Icons.flag_outlined,
                        title: 'Report a problem',
                        onTap: () {},
                      ),
                      const Divider(color: Colors.grey),
                      CustomListTile(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogoutScreen()));
                        },
                        icon: Icons.logout,
                        title: 'Log out',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: Icon(
            icon,
          ),
          onPressed: () {},
        ),
      ),
      title: Text(
        title,
      ),
      onTap: onTap,
    );
  }
}
