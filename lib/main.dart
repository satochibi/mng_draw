import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/models/settings_model.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/models/strokes_model.dart';
import 'package:mng_draw/models/achievement_model.dart';
import 'package:mng_draw/widgets/switch_screen_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PenModel>(create: (_) => PenModel()),
        ChangeNotifierProvider<StrokesModel>(create: (_) => StrokesModel()),
        ChangeNotifierProvider<SettingsModel>(create: (_) => SettingsModel()),
        ChangeNotifierProvider<AchievementModel>(
            create: (_) => AchievementModel())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
              color: Colors.white,
              child:
                  const SafeArea(child: SwitchScreen(mode: ScreenType.edit)))),
    );
  }
}
