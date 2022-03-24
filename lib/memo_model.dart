import 'package:flutter/widgets.dart';

class MemoModel extends ChangeNotifier {
  int _aspectRatioW = 4;
  int _aspectRatioH = 3;
  double canvasScale = 1;

  MemoModel(this._aspectRatioW, this._aspectRatioH);

  double get aspectRatio => _aspectRatioW.toDouble() / _aspectRatioH.toDouble();
  int get aspectRatioW => _aspectRatioW;
}
