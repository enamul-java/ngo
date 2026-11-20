import 'package:flutter/material.dart';

import '../../core/moon_app_color.dart';

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE7ECF2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: MoonAppColor.teal.withOpacity(.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: MoonAppColor.teal),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(color: MoonAppColor.navy, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style:  TextStyle(color: MoonAppColor.muted, fontSize: 11)),
      ],
    ),
  );
}
