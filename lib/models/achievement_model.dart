import 'package:flutter/widgets.dart';

class AchievementModel extends ChangeNotifier {
  Offset? prevPositionOfPen;
  Offset? velocityOfPen;

  int _totalDistanceOfPenRun = 0;
  int _totalNumberOfPenStrokes = 0;

  int get totalDistanceOfPenRun => _totalDistanceOfPenRun;

  set totalDistanceOfPenRun(int value) {
    _totalDistanceOfPenRun = value;
    notifyListeners();
  }

  int get totalNumberOfPenStrokes => _totalNumberOfPenStrokes;

  set totalNumberOfPenStrokes(int value) {
    _totalNumberOfPenStrokes = value;
    notifyListeners();
  }
}
