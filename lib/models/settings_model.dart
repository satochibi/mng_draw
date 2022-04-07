import 'package:flutter/widgets.dart';

class SettingsModel extends ChangeNotifier {
  int _screentoneScale = 1;
  bool refreshAll = false;

  bool _isClip = false;

  SettingsModel();

  int get screentoneScale => _screentoneScale;

  set screentoneScale(int scale) {
    _screentoneScale = scale;
    refreshAll = true;
    notifyListeners();
  }

  bool get isClip => _isClip;

  set isClip(bool clip) {
    _isClip = clip;
    notifyListeners();
  }
}
