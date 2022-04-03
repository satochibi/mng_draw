import 'package:flutter/material.dart';
import 'package:mng_draw/screens/edit_screen.dart';
import 'package:mng_draw/screens/sample_screen.dart';

enum ScreenType { edit, sample }

class SwitchScreen extends StatelessWidget {
  final ScreenType mode;
  const SwitchScreen({Key? key, required this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case ScreenType.edit:
        return const EditScreen();
      case ScreenType.sample:
        return const SampleScreen();
    }
  }
}
