import 'package:flutter/widgets.dart';
import 'package:mng_draw/screentone.dart';

class PenModel extends ChangeNotifier {
  Color _color = const Color(0xff000000);
  double _width = 10;
  Screentone _screentone = Screentone.checkered();

  PenModel();

  Color get color => _color;
  set color(Color color) {
    _color = color;
    notifyListeners();
  }

  double get width => _width;
  set width(double width) {
    _width = width;
    notifyListeners();
  }

  Screentone get screentone => _screentone;
  set screentone(Screentone screentone) {
    _screentone = screentone;
    notifyListeners();
  }
}
