import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SettingsModel extends ChangeNotifier {
  int _screentoneScale = 1;
  bool refreshAll = false;

  SettingsModel();

  int get screentoneScale => _screentoneScale;

  set screentoneScale(int scale) {
    _screentoneScale = scale;
    refreshAll = true;
    notifyListeners();
  }
}
