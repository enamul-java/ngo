import 'package:flutter/material.dart';

import '../../core/moon_app_color.dart';
import '../../core/moon_app_data.dart';
import 'case_card.dart';
import 'case_details.dart';
import 'case_record.dart';

class AlertsPage extends StatefulWidget {
  final VoidCallback onReport;

  const AlertsPage({super.key, required this.onReport});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {

  String query = '';
  String urgency = 'সব';

  @override
  Widget build(BuildContext context) {
    final filtered = demoCases.where((c) {
      final matchesQuery = '${c.id} ${c.location} ${c.age}'
          .toLowerCase()
          .contains(query.toLowerCase());

      final matchesUrgency = urgency == 'সব' || c.status == urgency;

      return matchesQuery && matchesUrgency;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'কেস আইডি বা এলাকা খুঁজুন',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['সব', 'জরুরি', 'উচ্চ ঝুঁকি', 'সাধারণ']
              .map(
                (value) => ChoiceChip(
                  label: Text(value),
                  selected: urgency == value,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        urgency = value;
                      });
                    }
                  },
                  selectedColor: MoonAppColor.teal.withOpacity(0.15),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 12),

        Text(
          '${filtered.length}টি সতর্কতা',
          style:  TextStyle(color:  MoonAppColor.muted, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 8),

        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('কোনো সতর্কতা পাওয়া যায়নি')),
          ),

        ...filtered.map(
          (c) => CaseCard(item: c, onTap: () => _openCase(context, c)),
        ),

        const SizedBox(height: 10),

        FilledButton.icon(
          onPressed: widget.onReport,
          icon: const Icon(Icons.add),
          label: const Text('নতুন রিপোর্ট জমা দিন'),
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
