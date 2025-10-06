import 'package:flutter/material.dart';
import 'package:sounds_cool/helpers/color_manager.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor2,
      body: Center(
        child: Text('Edit Screen'),
      ),
    );
  }
}
