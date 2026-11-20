
import 'package:flutter/material.dart';

import 'main_shell.dart';


class MunAlertApp extends StatelessWidget {
  const MunAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF142A4F);
    const teal = Color(0xFF0E8B83);
    return MaterialApp(
      title: 'MUN ALERT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: navy,
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(color: navy, fontSize: 20, fontWeight: FontWeight.w800),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDCE4ED))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDCE4ED))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: teal, width: 1.5)),
        ),
      ),
      home: const MainShell(),
    );
  }
}
















