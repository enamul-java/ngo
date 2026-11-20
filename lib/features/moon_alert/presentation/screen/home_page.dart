import 'package:flutter/material.dart';

import '../../core/moon_app_color.dart';
import '../../core/moon_app_data.dart';
import 'case_card.dart';
import 'case_details.dart';
import 'case_record.dart';
import 'future_title_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onReport, onAlerts;

  const HomePage({super.key, required this.onReport, required this.onAlerts});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              colors: [MoonAppColor.navy, Color(0xFF20547A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -20,
                child: Icon(
                  Icons.shield_rounded,
                  size: 150,
                  color: Colors.white.withOpacity(.07),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.13),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'শিশুর নিরাপত্তায় একসাথে',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'প্রতিটি মুহূর্ত\nগুরুত্বপূর্ণ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      height: 1.22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'নিখোঁজ শিশুর তথ্য দিন, সতর্কতা ছড়িয়ে দিন এবং নিরাপদে পরিবারে ফিরিয়ে আনতে সহায়তা করুন।',
                    style: TextStyle(
                      color: Color(0xFFE2EDF7),
                      height: 1.55,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: MoonAppColor.urgentRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: onReport,
                          icon: const Icon(Icons.warning_amber_rounded),
                          label: const Text('নিখোঁজ রিপোর্ট'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => _notice(
                            context,
                            'শিশু পাওয়া গেলে নিরাপদে কর্তৃপক্ষকে জানান।',
                          ),
                          icon: const Icon(Icons.people_alt_outlined),
                          label: const Text('শিশু পাওয়া গেছে'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: Text(
                'সাম্প্রতিক সতর্কতা',
                style: TextStyle(
                  fontSize: 19,
                  color: MoonAppColor.navy,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(onPressed: onAlerts, child: const Text('সব দেখুন  →')),
          ],
        ),
        const SizedBox(height: 4),
        ...demoCases
            .take(3)
            .map(
              (item) =>
                  CaseCard(item: item, onTap: () => _openCase(context, item)),
            ),
        const SizedBox(height: 12),
        Text(
          'আমাদের অঙ্গীকার',
          style: TextStyle(
            fontSize: 19,
            color: MoonAppColor.navy,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: FeatureTile(
                icon: Icons.verified_user_outlined,
                title: 'যাচাইকৃত তথ্য',
                subtitle: 'বিশ্বাসযোগ্য রিপোর্ট',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: FeatureTile(
                icon: Icons.location_on_outlined,
                title: 'স্থানভিত্তিক সতর্কতা',
                subtitle: 'প্রাসঙ্গিক এলাকার খবর',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

void _openCase(BuildContext context, CaseRecord c) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (_) => CaseDetailPage(item: c)));

void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
