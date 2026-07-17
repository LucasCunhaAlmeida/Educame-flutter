import 'package:flutter/material.dart';

import 'features/login/view/login_page.dart';

void main() {
  runApp(const EducameApp());
}

class EducameApp extends StatelessWidget {
  const EducameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}