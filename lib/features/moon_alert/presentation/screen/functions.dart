import 'package:flutter/material.dart';

import 'case_details.dart';
import 'case_record.dart';

void _openCase(BuildContext context, CaseRecord c) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (_) => CaseDetailPage(item: c)));

void _notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
