import 'package:flutter/material.dart';

import '../../core/moon_app_color.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final age = TextEditingController();
  final location = TextEditingController();
  final details = TextEditingController();
  final phone = TextEditingController();
  String gender = 'নির্বাচন করুন';
  DateTime? date;
  bool consent = false;
  bool photoAdded = false;
  int step = 0;

  @override
  void dispose() {
    name.dispose();
    age.dispose();
    location.dispose();
    details.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F6),
            borderRadius: BorderRadius.circular(18),
          ),
          child:  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_outline, color: MoonAppColor.teal),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'শিশুর নিরাপত্তা ও গোপনীয়তা আমাদের অগ্রাধিকার। জরুরি বিপদে স্থানীয় জরুরি সেবা বা আইনশৃঙ্খলা বাহিনীর সঙ্গে যোগাযোগ করুন।',
                  style: TextStyle(color: MoonAppColor.navy, fontSize: 12, height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            for (int i = 0; i < 4; i++)
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: i <= step
                          ? MoonAppColor.teal
                          : const Color(0xFFE1E7EE),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: i <= step ? Colors.white : MoonAppColor.navy,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ['শিশুর তথ্য', 'শেষ দেখা', 'যোগাযোগ', 'পর্যালোচনা'][i],
                      style:  TextStyle(fontSize: 10, color: MoonAppColor.muted),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          [
            'শিশুর তথ্য',
            'শেষ কোথায় দেখা গেছে',
            'রিপোর্টকারীর তথ্য',
            'রিপোর্ট পর্যালোচনা',
          ][step],
          style:  TextStyle(
            color: MoonAppColor.navy,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        if (step == 0) ...[
          InkWell(
            onTap: () => setState(() => photoAdded = !photoAdded),
            child: Container(
              height: 125,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(
                  color: const Color(0xFFCBD8E5),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    photoAdded
                        ? Icons.check_circle
                        : Icons.add_a_photo_outlined,
                    size: 30,
                    color: MoonAppColor.teal,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    photoAdded
                        ? 'ছবি যোগ করা হয়েছে (ডেমো)'
                        : 'ছবি যোগ করতে ট্যাপ করুন',
                    style:  TextStyle(
                      color: MoonAppColor.navy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                   Text(
                    'এই ডেমোতে প্রকৃত ফাইল আপলোড হয় না',
                    style: TextStyle(color: MoonAppColor.muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _field(name, 'শিশুর নাম বা পরিচিতি', required: true),
          const SizedBox(height: 12),
          _field(age, 'বয়স', required: true, keyboard: TextInputType.number),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: gender,
            decoration: const InputDecoration(labelText: 'লিঙ্গ *'),
            items: const [
              'নির্বাচন করুন',
              'ছেলে',
              'মেয়ে',
              'অন্যান্য',
            ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => gender = v ?? gender),
            validator: (v) =>
                v == 'নির্বাচন করুন' ? 'একটি বিকল্প নির্বাচন করুন' : null,
          ),
        ] else if (step == 1) ...[
          _field(location, 'শেষ দেখা যাওয়ার স্থান', required: true),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () =>
                _notice(context, 'লাইভ ম্যাপের জন্য Maps API সংযোগ করতে হবে।'),
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('ম্যাপে স্থান নির্বাচন (ডেমো)'),
          ),
          const SizedBox(height: 12),
          _field(details, 'শেষ দেখা যাওয়ার বিবরণ', required: true, maxLines: 4),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final d = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
              );
              if (d != null) setState(() => date = d);
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              date == null
                  ? 'শেষ দেখা যাওয়ার তারিখ নির্বাচন'
                  : '${date!.day}/${date!.month}/${date!.year}',
            ),
          ),
        ] else if (step == 2) ...[
          _field(
            phone,
            'যোগাযোগের মোবাইল নম্বর',
            required: true,
            keyboard: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: consent,
            onChanged: (v) => setState(() => consent = v ?? false),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text(
              'আমি নিশ্চিত করছি যে দেওয়া তথ্য আমার জানা মতে সঠিক এবং যাচাইয়ের জন্য যোগাযোগ করা যেতে পারে।',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            activeColor: MoonAppColor.teal,
          ),
        ] else ...[
          _review('শিশুর নাম/পরিচিতি', name.text),
          _review('বয়স', age.text),
          _review('লিঙ্গ', gender),
          _review('শেষ দেখা স্থান', location.text),
          _review('বিবরণ', details.text),
          _review('যোগাযোগ', phone.text),
          const SizedBox(height: 10),
           Text(
            'জমা দেওয়ার পর কর্তৃপক্ষ যাচাই করতে পারে। এই ডেমো অ্যাপ কোনো সার্ভারে তথ্য পাঠায় না।',
            style: TextStyle(color: MoonAppColor.muted, fontSize: 12, height: 1.5),
          ),
        ],
        const SizedBox(height: 22),
        Row(
          children: [
            if (step > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => step--),
                  child: const Text('পেছনে'),
                ),
              ),
            if (step > 0) const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  if (step < 3) {
                    if (step == 0 &&
                        !(formKey.currentState?.validate() ?? false))
                      return;
                    if (step == 1 &&
                        (location.text.trim().isEmpty ||
                            details.text.trim().isEmpty)) {
                      _notice(context, 'প্রয়োজনীয় তথ্য পূরণ করুন');
                      return;
                    }
                    if (step == 2 && (phone.text.trim().isEmpty || !consent)) {
                      _notice(
                        context,
                        'মোবাইল নম্বর দিন এবং সম্মতি নিশ্চিত করুন',
                      );
                      return;
                    }
                    setState(() => step++);
                  } else {
                    _notice(
                      context,
                      'ডেমো সম্পন্ন। সার্ভার/API যুক্ত করলে রিপোর্ট জমা হবে।',
                    );
                    setState(() {
                      step = 0;
                      name.clear();
                      age.clear();
                      location.clear();
                      details.clear();
                      phone.clear();
                      gender = 'নির্বাচন করুন';
                      consent = false;
                      photoAdded = false;
                      date = null;
                    });
                  }
                },
                icon: Icon(
                  step == 3 ? Icons.send_rounded : Icons.arrow_forward_rounded,
                ),
                label: Text(step == 3 ? 'রিপোর্ট জমা দিন' : 'পরবর্তী'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    ),
  );

  Widget _field(
    TextEditingController c,
    String label, {
    bool required = false,
    TextInputType? keyboard,
    int maxLines = 1,
  }) => TextFormField(
    controller: c,
    keyboardType: keyboard,
    maxLines: maxLines,
    validator: required
        ? (v) => (v == null || v.trim().isEmpty) ? 'এই তথ্যটি প্রয়োজন' : null
        : null,
    decoration: InputDecoration(labelText: label + (required ? ' *' : '')),
  );

  Widget _review(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style:  TextStyle(color: MoonAppColor.muted, fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'উল্লেখ করা হয়নি' : value,
            style:  TextStyle(color: MoonAppColor.navy, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
