import 'package:flutter/widgets.dart';

class AchievementModel extends ChangeNotifier {
  Offset? prevPositionOfPen;
  Offset? velocityOfPen;

  double _totalDistanceOfPenRun = 0;
  int _totalNumberOfPenStrokes = 0;

  double get totalDistanceOfPenRun => _totalDistanceOfPenRun;

  set totalDistanceOfPenRun(double value) {
    _totalDistanceOfPenRun = value;
    notifyListeners();
  }

  int get totalNumberOfPenStrokes => _totalNumberOfPenStrokes;

  set totalNumberOfPenStrokes(int value) {
    _totalNumberOfPenStrokes = value;
    notifyListeners();
  }
}
