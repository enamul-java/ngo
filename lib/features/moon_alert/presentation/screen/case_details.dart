import 'package:flutter/material.dart';

import '../../core/moon_app_color.dart';
import 'case_record.dart';

class CaseDetailPage extends StatelessWidget {
  final CaseRecord item;

  const CaseDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('সতর্কতার বিস্তারিত')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0F6),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 100,
            color: Color(0xFF71839A),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                item.id,
                style:  TextStyle(
                  color: MoonAppColor.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Chip(
              label: Text(item.status),
              backgroundColor: item.statusColor.withOpacity(.12),
              labelStyle: TextStyle(
                color: item.statusColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${item.age} · ${item.gender}',
          style:  TextStyle(
            color: MoonAppColor.navy,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _detailLine(
          Icons.location_on_outlined,
          'শেষ দেখা স্থান',
          item.location,
        ),
        _detailLine(Icons.access_time, 'সময়', item.lastSeen),
        _detailLine(Icons.info_outline, 'বিবরণ', item.description),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4E5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Text(
            'গুরুত্বপূর্ণ: শিশুর পরিচয় ও অবস্থান সম্পর্কিত তথ্য যাচাই ছাড়া প্রকাশ করবেন না। জরুরি তথ্য সংশ্লিষ্ট কর্তৃপক্ষকে জানান।',
            style: TextStyle(
              color: Color(0xFF85520A),
              height: 1.5,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _notice(
            context,
            'তথ্য জানানোর জন্য কর্তৃপক্ষের যাচাইকৃত যোগাযোগ চ্যানেল যুক্ত করতে হবে।',
          ),
          icon: const Icon(Icons.flag_outlined),
          label: const Text('তথ্য জানাতে চাই'),
        ),
      ],
    ),
  );
}

Widget _detailLine(IconData icon, String title, String text) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: MoonAppColor.teal),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style:  TextStyle(color: MoonAppColor.muted, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              text,
              style:  TextStyle(
                color: MoonAppColor.navy,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );