import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:mng_draw/classes/screentone.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/models/memo_model.dart';
import 'package:mng_draw/models/settings_model.dart';

class StrokesModel extends ChangeNotifier {
  List<Stroke> _strokes = [];
  MemoModel memo = MemoModel();
  SettingsModel settings = SettingsModel();

  get all => _strokes;

  void add(SettingsModel settingsModel, MemoModel memoModel, PenModel pen,
      Offset offset) {
    memo = memoModel;
    settings = settingsModel;
    _strokes.add(Stroke(pen.width, pen.color, pen.screentone)
      ..add(offset / memoModel.canvasScale));
    notifyListeners();
  }

  void update(Offset offset) {
    _strokes.last.add(offset / memo.canvasScale);
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

  Stroke(this.width, this.color, this.screentone);

  add(Offset offset) {
    points.add(offset);
  }
}
