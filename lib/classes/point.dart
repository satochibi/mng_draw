import 'dart:ui' as ui;

class Point extends ui.Offset {
  const Point(double dx, double dy) : super(dx, dy);

  @override
  Point scale(double scaleX, double scaleY) {
    var anOffset = super.scale(scaleX, scaleY);
    return Point(anOffset.dx, anOffset.dy);
  }

  // 左上を原点として縦横size分埋める
  List<Point> fillSquare(Point aPoint, int size) {
    List<Point> result = [];
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        result.add(Point(x + aPoint.dx, y + aPoint.dy));
      }
    }
    return result;
  }
}
