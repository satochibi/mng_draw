import 'dart:ui';
import 'package:mng_draw/point.dart';
import 'package:mng_draw/paint_colors.dart';

class Screentone {
  int width;
  int height;
  List<Point> data;

  // コンストラクタ
  Screentone(this.width, this.height, this.data);

  // このスクリーントーンのスケールした新しいスクリーントーンを返す
  Screentone scale(int factor) {
    // それぞれを拡大
    int newWidth = width * factor;
    int newHeight = height * factor;
    List<Point> newData = data
        .map((aPoint) => aPoint.scale(factor.toDouble(), factor.toDouble()))
        .toList();

    newData = newData
        .map((aPoint) => aPoint.fillSquare(aPoint, factor))
        .expand((i) => i)
        .toList();

    return Screentone(newWidth, newHeight, newData);
  }

  @override
  String toString() {
    return "w: $width, h: $height, data: $data";
  }

  Future<Image> toImage(Color color) {
    var aPatternPosition = data;

    var aNextPatternPosition =
        aPatternPosition.map((e) => e + Point(width.toDouble(), 0)).toList();

    var aPaint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = false;

    // FlutterのPictureRecorderのバグのため、
    // パターンイメージを1x1タイルではなく、2x1タイルで描画
    //
    // PictureRecorderのバグ
    // 環境によって原点が(0,0)ではなく、(1,0)になるバグ

    var pictureRecorder = PictureRecorder();
    Canvas patternCanvas = Canvas(pictureRecorder);

    patternCanvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100),
        Paint()..color = PaintColors.transparent);

    patternCanvas.drawPoints(PointMode.points, aPatternPosition, aPaint);
    patternCanvas.drawPoints(PointMode.points, aNextPatternPosition, aPaint);

    final aPatternPicture = pictureRecorder.endRecording();

    return aPatternPicture.toImage(width, height);
  }

  static Screentone normal() {
    return Screentone(1, 1, const [Point(0, 0)]);
  }

  static Screentone rough3x3() {
    return Screentone(3, 3, const [Point(2, 2)]);
  }

  static Screentone rough2x2() {
    return Screentone(2, 2, const [Point(1, 1)]);
  }

  static Screentone beads4x4() {
    return Screentone(4, 4, const [
      Point(2, 0),
      Point(1, 1),
      Point(3, 1),
      Point(0, 2),
      Point(1, 3),
      Point(3, 3)
    ]);
  }

  static Screentone stripeX() {
    return Screentone(1, 2, const [Point(0, 0)]);
  }

  static Screentone stripeY() {
    return Screentone(2, 1, const [Point(0, 0)]);
  }

  static Screentone checkered() {
    return Screentone(2, 2, const [Point(1, 0), Point(0, 1)]);
  }

  static Screentone dense2x2() {
    return Screentone(2, 2, const [Point(0, 0), Point(1, 0), Point(0, 1)]);
  }

  static Screentone dense3x3() {
    return Screentone(3, 3, const [
      Point(0, 0),
      Point(1, 0),
      Point(2, 0),
      Point(0, 1),
      Point(1, 1),
      Point(2, 1),
      Point(0, 2),
      Point(1, 2)
    ]);
  }

  static Screentone leftHatching8x8() {
    return Screentone(8, 8, const [
      Point(1, 0),
      Point(2, 1),
      Point(3, 2),
      Point(4, 3),
      Point(5, 4),
      Point(6, 5),
      Point(7, 6),
      Point(0, 7)
    ]);
  }

  static Screentone rightHatching8x8() {
    return Screentone(8, 8, const [
      Point(7, 0),
      Point(6, 1),
      Point(5, 2),
      Point(4, 3),
      Point(3, 4),
      Point(2, 5),
      Point(1, 6),
      Point(0, 7)
    ]);
  }
}
