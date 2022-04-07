import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:mng_draw/classes/screentone.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/models/settings_model.dart';

class StrokesModel extends ChangeNotifier {
  List<Stroke> _strokes = [];
  SettingsModel settings = SettingsModel();

  get all => _strokes;

  void add(SettingsModel settingsModel, PenModel pen, int artBoardScaleFactor,
      Offset offset) {
    settings = settingsModel;
    _strokes.add(
        Stroke(pen.width, pen.color, pen.screentone, artBoardScaleFactor)
          ..add(offset));
    notifyListeners();
  }

  void update(Offset offset) {
    _strokes.last.add(offset);
    notifyListeners();
  }

  void clear() {
    _strokes = [];
    notifyListeners();
  }

  Future<void> screentoneImage() async {
    _strokes.forEach((stroke) async {
      if (settings.refreshAll) {
        stroke.screentoneImage = await stroke.screentone
            .scale(settings.screentoneScale)
            .toImage(stroke.color);
        notifyListeners();
      } else {
        // 処理軽減のため、スクリーントーンがnullのときだけスクリーントーン画像をセット
        stroke.screentoneImage ??= await stroke.screentone
            .scale(settings.screentoneScale)
            .toImage(stroke.color);
      }
    });

    if (settings.refreshAll) {
      settings.refreshAll = false;
    }
  }
}

class Stroke {
  final List<Offset> points = [];
  Color color;
  Screentone screentone;
  ui.Image? screentoneImage;
  double width;
  int artBoardScaleFactor;

  Stroke(this.width, this.color, this.screentone, this.artBoardScaleFactor);

  add(Offset offset) {
    points.add(offset);
  }
}
