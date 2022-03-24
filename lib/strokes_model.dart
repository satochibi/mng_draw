import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:mng_draw/memo_model.dart';
import 'package:mng_draw/screentone.dart';

class StrokesModel extends ChangeNotifier {
  List<Stroke> _strokes = [];
  MemoModel memoModel = MemoModel(4, 3);

  get all => _strokes;

  void add(MemoModel memoModel, PenModel pen, Offset offset) {
    this.memoModel = memoModel;
    _strokes.add(Stroke(pen.width, pen.color, pen.screentone)
      ..add(offset / memoModel.canvasScale));
    notifyListeners();
  }

  void update(Offset offset) {
    _strokes.last.add(offset / memoModel.canvasScale);
    notifyListeners();
  }

  void clear() {
    _strokes = [];
    notifyListeners();
  }

  Future<void> screentoneImage() async {
    _strokes.forEach((stroke) async {
      // 処理軽減のため、スクリーントーンがnullのときだけスクリーントーン画像をセット
      stroke.screentoneImage ??= await stroke.screentone.toImage(stroke.color);
    });
    // notifyListeners();
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
