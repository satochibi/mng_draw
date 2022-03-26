import 'package:flutter/material.dart';
import 'package:mng_draw/settings_model.dart';
import 'package:provider/provider.dart';

class ChooseSettingsScreen extends StatelessWidget {
  const ChooseSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: Slider(
        label: '${settings.screentoneScale.round()}',
        min: 1,
        max: 20,
        value: settings.screentoneScale.toDouble(),
        activeColor: Colors.orange,
        inactiveColor: Colors.blueAccent,
        divisions: 49,
        onChanged: (double value) {
          settings.screentoneScale = value.round();
        },
      ),
    );
  }
}
