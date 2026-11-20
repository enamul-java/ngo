import 'package:flutter/material.dart';
import 'package:ngo/features/moon_alert/presentation/screen/report_page.dart';
import 'package:ngo/features/moon_alert/presentation/screen/safety_page.dart';

import '../../../dashboard/presentation/view/profile_page.dart';
import '../../core/moon_app_color.dart';
import 'alert_page.dart';
import 'home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;
  final titles = const [
    'MUN ALERT',
    'সতর্কতা',
    'রিপোর্ট করুন',
    'নিরাপত্তা',
    'প্রোফাইল',
  ];

  void goToReport() => setState(() => index = 2);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onReport: goToReport, onAlerts: () => setState(() => index = 1)),
      AlertsPage(onReport: goToReport),
      ReportPage(),
      const SafetyPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: MoonAppColor.teal.withOpacity(.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.shield_rounded,
                color: MoonAppColor.teal,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[index],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: MoonAppColor.navy,
                  ),
                ),
                if (index == 0)
                  Text(
                    'Bangladesh Missing Child Alert',
                    style: TextStyle(
                      fontSize: 10,
                      color: MoonAppColor.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _notice(context, 'নতুন নোটিফিকেশন নেই'),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        backgroundColor: Colors.white,
        indicatorColor: MoonAppColor.teal.withOpacity(.12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'হোম',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign_rounded),
            label: 'সতর্কতা',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'রিপোর্ট',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'নিরাপত্তা',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'প্রোফাইল',
          ),
        ],
      ),
    );
  }
}

void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
