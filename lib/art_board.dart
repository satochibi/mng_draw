import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mng_draw/screentone.dart';
import 'package:mng_draw/paint_colors.dart' as colors;
import 'package:mng_draw/point.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:mng_draw/strokes_model.dart';

class ArtBoard extends StatelessWidget {
  const ArtBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    final strokes = Provider.of<StrokesModel>(context);

    return FutureBuilder(
      future: getPattern(colors.blue(), Screentone.dense2x2()),
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        return FakeDevicePixelRatio(
          fakeDevicePixelRatio: 1.0,
          child: GestureDetector(
            onPanDown: (details) => strokes.add(pen, details.localPosition),
            onPanUpdate: (details) => strokes.update(details.localPosition),
            child: CustomPaint(
              painter: _SamplePainter(strokes, snapshot.data),
            ),
          ),
        );
      },
    );
  }
}

Future<ui.Image> getPattern(Color color, Screentone screentone) async {
  var aPatternPosition = screentone.data;
  var width = screentone.width;
  var height = screentone.height;

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

  var pictureRecorder = ui.PictureRecorder();
  Canvas patternCanvas = Canvas(pictureRecorder);

  patternCanvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100),
      Paint()..color = colors.transparent());

  patternCanvas.drawPoints(ui.PointMode.points, aPatternPosition, aPaint);
  patternCanvas.drawPoints(ui.PointMode.points, aNextPatternPosition, aPaint);

  final aPatternPicture = pictureRecorder.endRecording();
  return aPatternPicture.toImage(width, height);
}

// https://stackoverflow.com/questions/70866283/custompainter-drawimage-throws-an-exception-object-has-been-disposed
// https://stackoverflow.com/questions/52752298/how-to-draw-different-pattern-in-flutter
class _SamplePainter extends CustomPainter {
  // final ui.Image? aPattern;
  final StrokesModel strokes;
  final ui.Image? image;

  _SamplePainter(this.strokes, this.image);

  @override
  void paint(Canvas canvas, Size size) {
    // 背景を描画
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = colors.artBoardBackground());

    // 一画ごとに描画
    strokes.all.forEach((Stroke stroke) {
      var path = Path();

      if (stroke.points.length == 1) {
        path.moveTo(stroke.points[0].dx, stroke.points[0].dy);
        path.lineTo(stroke.points[0].dx, stroke.points[0].dy);
      } else {
        stroke.points.asMap().forEach((int index, Offset point) {
          if (index == 0) {
            path.moveTo(point.dx, point.dy);
          } else {
            path.lineTo(point.dx, point.dy);
          }
        });
      }

      if (image != null) {
        final paint = Paint()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke.width
          ..isAntiAlias = false
          ..shader = ImageShader(image!, TileMode.repeated, TileMode.repeated,
              Matrix4.identity().storage);

        canvas.drawPath(path, paint);
      }
    });
  }

  @override
  bool shouldRepaint(_SamplePainter oldDelegate) {
    return true;
  }
}

class FakeDevicePixelRatio extends StatelessWidget {
  final num fakeDevicePixelRatio;
  final Widget child;

  const FakeDevicePixelRatio(
      {Key? key, required this.fakeDevicePixelRatio, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio =
        WidgetsBinding.instance?.window.devicePixelRatio ?? 1;

    final ratio = fakeDevicePixelRatio / devicePixelRatio;

    return FractionallySizedBox(
        widthFactor: 1 / ratio,
        heightFactor: 1 / ratio,
        child: Transform.scale(scale: ratio, child: child));
  }
}
