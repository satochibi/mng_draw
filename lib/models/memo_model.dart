import 'package:flutter/widgets.dart';

class MemoModel extends ChangeNotifier {
  double aspectRatioW = 4;
  double aspectRatioH = 3;
  double canvasScale = 1;

  MemoModel();

  double get aspectRatio => aspectRatioW.toDouble() / aspectRatioH.toDouble();
}
