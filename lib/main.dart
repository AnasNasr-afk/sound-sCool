import 'package:flutter/material.dart';

import 'features/home/home_screen.dart';

void main() {
  runApp(const SoundsCoolApp());
}


class SoundsCoolApp extends StatelessWidget {
  const SoundsCoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sounds Cool',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}




