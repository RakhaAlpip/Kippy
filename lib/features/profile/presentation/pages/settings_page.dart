import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/get_started_page.dart'; // Primary Color

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: GetStartedConstants.primaryColor,
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=12',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: GetStartedConstants.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Kippy User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '@kippy_fan_123',
                    style: TextStyle(color: GetStartedConstants.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: GetStartedConstants.primaryColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: GetStartedConstants.primaryColor.withAlpha(100),
                      ),
                    ),
                    child: const Text(
                      'Pro Member',
                      style: TextStyle(
                        color: GetStartedConstants.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('ACCOUNT', theme),
                  _SettingsCard(
                    theme: theme,
                    children: [
                      _SettingsTile(
                        icon: Icons.person,
                        title: 'Edit Profile',
                        theme: theme,
                        onTap: () {
                          Navigator.pushNamed(context, '/edit-profile');
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Password & Security',
                        theme: theme,
                      ),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy',
                        showDivider: false,
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _SectionTitle('PREFERENCES', theme),
                  _SettingsCard(
                    theme: theme,
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_none,
                        title: 'Notifications',
                        trailing: Switch(
                          value: true,
                          activeTrackColor: GetStartedConstants.primaryColor,
                          onChanged: (v) {},
                        ),
                        theme: theme,
                      ),
                      _SettingsTile(
                        icon: Icons.language,
                        title: 'Language',
                        showDivider: false,
                        theme: theme,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _SectionTitle('SUPPORT', theme),
                  _SettingsCard(
                    theme: theme,
                    children: [
                      _SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        theme: theme,
                      ),
                      _SettingsTile(
                        icon: Icons.bug_report_outlined,
                        title: 'Report a Bug',
                        showDivider: false,
                        theme: theme,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withAlpha(20),
                        foregroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Kippy v1.0.0',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final ThemeData theme;
  const _SectionTitle(this.title, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final ThemeData theme;
  const _SettingsCard({required this.children, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final bool showDivider;
  final ThemeData theme;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.showDivider = true,
    required this.theme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: GetStartedConstants.primaryColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: GetStartedConstants.primaryColor,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing:
              trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 64,
            color: theme.dividerColor.withAlpha(50),
          ),
      ],
    );
  }
}
