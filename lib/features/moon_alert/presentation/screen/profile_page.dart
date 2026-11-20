import 'package:flutter/material.dart';

import '../../core/moon_app_color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child:  Column(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: Color(0xFFE8F5F3),
              child: Icon(Icons.person_rounded, size: 42, color: MoonAppColor.teal),
            ),
            SizedBox(height: 12),
            Text(
              'অতিথি ব্যবহারকারী',
              style: TextStyle(
                color: MoonAppColor.navy,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'প্রোফাইল সম্পূর্ণ করতে সাইন ইন করুন',
              style: TextStyle(color: MoonAppColor.muted, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _ProfileOption(
        icon: Icons.person_outline,
        title: 'ব্যক্তিগত তথ্য',
        onTap: () => _notice(context, 'লগইন ও প্রোফাইল API প্রয়োজন'),
      ),
      _ProfileOption(
        icon: Icons.assignment_outlined,
        title: 'আমার রিপোর্ট',
        onTap: () => _notice(context, 'আপনার রিপোর্ট দেখতে লগইন প্রয়োজন'),
      ),
      _ProfileOption(
        icon: Icons.language,
        title: 'ভাষা',
        onTap: () => _notice(context, 'বাংলা বর্তমানে নির্বাচিত'),
      ),
      _ProfileOption(
        icon: Icons.privacy_tip_outlined,
        title: 'গোপনীয়তা নীতি',
        onTap: () =>
            _notice(context, 'প্রকাশের আগে অনুমোদিত গোপনীয়তা নীতি যুক্ত করুন'),
      ),
      _ProfileOption(
        icon: Icons.help_outline,
        title: 'সহায়তা',
        onTap: () => _notice(context, 'সহায়তা কেন্দ্র/API যুক্ত করতে হবে'),
      ),
    ],
  );
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: Icon(icon, color: MoonAppColor.teal),
      title: Text(
        title,
        style:  TextStyle(color: MoonAppColor.navy, fontWeight: FontWeight.w600),
      ),
      trailing:  Icon(Icons.chevron_right, color: MoonAppColor.muted),
      onTap: onTap,
    ),
  );
}

void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );

