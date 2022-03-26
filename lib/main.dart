import 'package:flutter/material.dart';
import 'package:mng_draw/edit_screen.dart';
import 'package:mng_draw/memo_model.dart';
import 'package:mng_draw/settings_model.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:mng_draw/strokes_model.dart';

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
        ChangeNotifierProvider<MemoModel>(create: (_) => MemoModel(4, 3)),
        ChangeNotifierProvider<SettingsModel>(create: (_) => SettingsModel())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Container(
              color: Colors.white, child: const SafeArea(child: EditScreen()))),
    );
  }
}
