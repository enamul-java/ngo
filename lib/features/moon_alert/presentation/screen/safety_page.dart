import 'package:flutter/material.dart';
import 'package:ngo/features/moon_alert/core/moon_app_color.dart';

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient:  LinearGradient(colors: [MoonAppColor.navy, Color(0xFF20547A)]),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.shield_moon_outlined, color: Colors.white, size: 40),
            SizedBox(height: 12),
            Text(
              'শিশুর নিরাপত্তা সবার দায়িত্ব',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'সঠিক তথ্য শেয়ার করুন, গুজব এড়িয়ে চলুন এবং শিশুর পরিচয় ও ব্যক্তিগত তথ্য সুরক্ষিত রাখুন।',
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const _SafetyTip(
        icon: Icons.phone_in_talk_outlined,
        title: 'জরুরি পরিস্থিতি',
        text:
            'তাৎক্ষণিক বিপদে স্থানীয় জরুরি সেবা বা আইনশৃঙ্খলা বাহিনীর সঙ্গে যোগাযোগ করুন।',
      ),
      const _SafetyTip(
        icon: Icons.fact_check_outlined,
        title: 'তথ্য যাচাই করুন',
        text:
            'শিশু সম্পর্কিত কোনো তথ্য প্রকাশ বা শেয়ার করার আগে উৎস যাচাই করুন।',
      ),
      const _SafetyTip(
        icon: Icons.privacy_tip_outlined,
        title: 'গোপনীয়তা বজায় রাখুন',
        text:
            'শিশুর ঠিকানা, ফোন নম্বর বা সংবেদনশীল তথ্য প্রকাশ্যে পোস্ট করবেন না।',
      ),
      const _SafetyTip(
        icon: Icons.handshake_outlined,
        title: 'নিজে ঝুঁকি নেবেন না',
        text:
            'সন্দেহজনক পরিস্থিতি দেখলে নিরাপদ দূরত্ব বজায় রেখে কর্তৃপক্ষকে জানান।',
      ),
    ],
  );
}

class _SafetyTip extends StatelessWidget {
  final IconData icon;
  final String title, text;

  const _SafetyTip({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MoonAppColor.teal.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: MoonAppColor.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    color: MoonAppColor.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style:  TextStyle(
                    color: MoonAppColor.muted,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
