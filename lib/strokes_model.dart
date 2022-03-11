import 'package:flutter/widgets.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:mng_draw/screentone.dart';

class StrokesModel extends ChangeNotifier {
  List<Stroke> _strokes = [];

  get all => _strokes;

  void add(PenModel pen, Offset offset) {
    _strokes.add(Stroke(pen.width, pen.color, pen.screentone)..add(offset));
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
}

class Stroke {
  final List<Offset> points = [];
  Color color;
  Screentone screentone;
  double width;

  Stroke(this.width, this.color, this.screentone);

  add(Offset offset) {
    points.add(offset);
  }
}