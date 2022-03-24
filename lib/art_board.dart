import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mng_draw/memo_model.dart';
import 'package:mng_draw/paint_colors.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:mng_draw/strokes_model.dart';
import 'package:mng_draw/fake_device_pixel_ratio_widget.dart';

class ArtBoard extends StatelessWidget {
  const ArtBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    final strokes = Provider.of<StrokesModel>(context);
    final memoModel = Provider.of<MemoModel>(context);

    return FutureBuilder(
      future: strokes.screentoneImage(),
      builder: (context, snapshot) {
        return Container(
          color: PaintColors.outOfRangeBackground,
          child: Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: memoModel.aspectRatio,
              child: FakeDevicePixelRatio(
                fakeDevicePixelRatio: 1.0,
                child: GestureDetector(
                  onPanDown: (details) =>
                      strokes.add(pen, details.localPosition),
                  onPanUpdate: (details) =>
                      strokes.update(details.localPosition),
                  child: ClipRect(
                    child: CustomPaint(
                      painter: _SamplePainter(strokes),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// https://stackoverflow.com/questions/70866283/custompainter-drawimage-throws-an-exception-object-has-been-disposed
// https://stackoverflow.com/questions/52752298/how-to-draw-different-pattern-in-flutter
class _SamplePainter extends CustomPainter {
  final StrokesModel strokes;

  _SamplePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    // 背景を描画
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = PaintColors.artBoardBackground);

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

      // 仮のペイント
      var paint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke.width
        ..isAntiAlias = false
        ..color = stroke.color;

      // スクリーントーンを生成したら、そのシェーダを作ってペイント
      if (stroke.screentoneImage != null) {
        paint = Paint()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke.width
          ..isAntiAlias = false
          ..shader = ImageShader(stroke.screentoneImage as ui.Image,
              TileMode.repeated, TileMode.repeated, Matrix4.identity().storage);
      }

      canvas.drawPath(path, paint);
    });
  }

  @override
  bool shouldRepaint(_SamplePainter oldDelegate) {
    return true;
  }
}
