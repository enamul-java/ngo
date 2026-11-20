import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}


class _CustomSettingsPageState extends State<SettingsPage> {
  bool _syncData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Section Heading
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Account Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Information'),
            subtitle: const Text('Update your name, email, and photo'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.shield),
            title: const Text('Privacy & Security'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),

          // Another Section Heading
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Preferences',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.sync),
            title: const Text('Auto Sync Data'),
            subtitle: const Text('Keep your information updated across devices'),
            value: _syncData,
            onChanged: (bool value) {
              setState(() {
                _syncData = value;
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}



class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkTheme = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
                onPressed: (context) {
                  // Navigate to Language settings screen
                },
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    _isDarkTheme = value;
                  });
                },
                initialValue: _isDarkTheme,
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Theme'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Security'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                initialValue: _notificationsEnabled,
                leading: const Icon(Icons.notifications),
                title: const Text('Enable Notifications'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password'),
                onPressed: (context) {
                  // Handle navigation
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
