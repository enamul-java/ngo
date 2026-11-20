import '../presentation/screen/case_record.dart';
import 'moon_app_color.dart';

final demoCases = <CaseRecord>[
  CaseRecord(
    id: 'MUN-2026-123456',
    name: 'শিশু পরিচয় গোপন',
    age: '৭ বছর',
    gender: 'ছেলে',
    location: 'মোহাম্মদপুর, ঢাকা',
    lastSeen: 'আজ, সকাল ৪:৩০',
    status: 'জরুরি',
    statusColor: MoonAppColor.urgentRed,
    description:
        'শেষবার শিশুটিকে মোহাম্মদপুর এলাকায় দেখা গেছে। তথ্য থাকলে কর্তৃপক্ষের সঙ্গে যোগাযোগ করুন।',
  ),
  CaseRecord(
    id: 'MUN-2026-123457',
    name: 'শিশু পরিচয় গোপন',
    age: '১০ বছর',
    gender: 'মেয়ে',
    location: 'পতেঙ্গা, চট্টগ্রাম',
    lastSeen: 'গতকাল, দুপুর ২:১৫',
    status: 'উচ্চ ঝুঁকি',
    statusColor: MoonAppColor.statusColor,
    description:
        'পরিবারের অনুমোদিত তথ্যের ভিত্তিতে এই সতর্কতা প্রকাশ করা হয়েছে।',
  ),
  CaseRecord(
    id: 'MUN-2026-123458',
    name: 'শিশু পরিচয় গোপন',
    age: '৫ বছর',
    gender: 'ছেলে',
    location: 'সাহেব বাজার, রাজশাহী',
    lastSeen: 'আজ, সকাল ১০:২০',
    status: 'সাধারণ',
    statusColor: MoonAppColor.statusColorGen,
    description:
        'আপনার কাছে নির্ভরযোগ্য তথ্য থাকলে রিপোর্ট করুন। নিজে ঝুঁকি নিয়ে অনুসন্ধান করবেন না।',
  ),
  CaseRecord(
    id: 'MUN-2026-123459',
    name: 'শিশু পরিচয় গোপন',
    age: '১২ বছর',
    gender: 'মেয়ে',
    location: 'খুলনা সদর, খুলনা',
    lastSeen: 'গতকাল, বিকাল ৫:১০',
    status: 'জরুরি',
    statusColor: MoonAppColor.urgentRed,
    description:
        'শিশুর নিরাপত্তাকে অগ্রাধিকার দিন এবং তথ্য যাচাই ছাড়া সামাজিক মাধ্যমে ছড়াবেন না।',
  ),
];
