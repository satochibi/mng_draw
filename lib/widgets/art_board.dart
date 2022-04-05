import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:mng_draw/classes/paint_colors.dart';
import 'package:mng_draw/models/settings_model.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/models/strokes_model.dart';
import 'package:mng_draw/widgets/fake_device_pixel_ratio_widget.dart';

class ArtBoardInfo {
  final Size aspectRatio;
  int scaleFactor = 1;
  Offset absolutePosition = Offset.zero;
  Size size = Size.zero;

  ArtBoardInfo(this.aspectRatio);

  sizeRecalculation(Size surfaceSize) {
    Rect artBoardRect = Rect.zero;

    //if (artBoardWidth < surfaceWidth)
    if (aspectRatio.width * surfaceSize.height <
        surfaceSize.width * aspectRatio.height) {
      //画面が横長
      final int artBoardHeight =
          (surfaceSize.height - (surfaceSize.height % aspectRatio.height))
              .round();
      scaleFactor = artBoardHeight ~/ aspectRatio.height;
      final int artBoardWidth = aspectRatio.width.round() * scaleFactor;

      artBoardRect = Rect.fromLTRB(
          (surfaceSize.width - artBoardWidth) / 2,
          0,
          (surfaceSize.width - artBoardWidth) / 2 + artBoardWidth,
          artBoardHeight.toDouble());
    } else {
      //画面が縦長
      final int artBoardWidth =
          (surfaceSize.width - (surfaceSize.width % aspectRatio.width)).round();
      scaleFactor = artBoardWidth ~/ aspectRatio.width;
      final int artBoardHeight = aspectRatio.height.round() * scaleFactor;

      artBoardRect = Rect.fromLTRB(
          0,
          (surfaceSize.height - artBoardHeight) / 2,
          artBoardWidth.toDouble(),
          (surfaceSize.height - artBoardHeight) / 2 + artBoardHeight);
    }

    absolutePosition = Offset(artBoardRect.left, artBoardRect.top);
    size = Size((artBoardRect.right - artBoardRect.left).abs(),
        (artBoardRect.bottom - artBoardRect.top).abs());
  }

  Matrix4 matrixToAspectCoordinates() {
    Matrix4 A = Matrix4.translationValues(
        -absolutePosition.dx, -absolutePosition.dy, 0);
    Matrix4 B = Matrix4.diagonal3Values(
        1.0 / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
    return B * A;
  }

  Matrix4 inverseMatrixToAbsoluteCoordinates() {
    return Matrix4.inverted(matrixToAspectCoordinates());
  }

  Vector3 offsetToVector3(Offset anOffset) {
    return Vector3(anOffset.dx, anOffset.dy, 1);
  }

  Offset vector3ToOffset(Vector3 vector3) {
    return Offset(vector3.x, vector3.y);
  }

  Offset inputToModel(Offset aInputOffset) {
    return vector3ToOffset(
        matrixToAspectCoordinates() * offsetToVector3(aInputOffset));
  }

  Offset modelToOutput(Offset aModelOffset) {
    return vector3ToOffset(
        inverseMatrixToAbsoluteCoordinates() * offsetToVector3(aModelOffset));
  }
}

class ArtBoard extends StatelessWidget {
  double height;
  double width;
  final bool isDrawable;
  final ArtBoardInfo artBoardInfo;

  ArtBoard(
      {Key? key,
      this.width = double.infinity,
      this.height = double.infinity,
      required this.artBoardInfo,
      required this.isDrawable})
      : super(key: key) {
    if (width == double.infinity) {
      if (height != double.infinity) {
        width = artBoardInfo.aspectRatio.width *
            (height / artBoardInfo.aspectRatio.height);
      }
    } else if (height == double.infinity) {
      if (width != double.infinity) {
        height = artBoardInfo.aspectRatio.height *
            (width / artBoardInfo.aspectRatio.width);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    final strokes = Provider.of<StrokesModel>(context);
    final settings = Provider.of<SettingsModel>(context);

    return FutureBuilder(
        future: strokes.screentoneImage(),
        builder: (context, snapshot) {
          return SizedBox(
            height: height,
            width: width,
            child: FakeDevicePixelRatio(
              fakeDevicePixelRatio: 1.0,
              child: GestureDetector(
                onPanDown: (details) => strokes.add(settings, pen,
                    artBoardInfo.inputToModel(details.localPosition)),
                onPanUpdate: (details) => strokes
                    .update(artBoardInfo.inputToModel(details.localPosition)),
                onPanEnd: (details) => debugPrint("end"),
                child: ClipRect(
                  child: CustomPaint(
                    painter: _SamplePainter(artBoardInfo, strokes),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

// https://stackoverflow.com/questions/70866283/custompainter-drawimage-throws-an-exception-object-has-been-disposed
// https://stackoverflow.com/questions/52752298/how-to-draw-different-pattern-in-flutter
class _SamplePainter extends CustomPainter {
  final StrokesModel strokes;
  final ArtBoardInfo artBoardInfo;

  _SamplePainter(this.artBoardInfo, this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    // memo.canvasScale = size.width / memo.aspectRatio.width;
    // debugPrint(memo.canvasScale.toString());

    // 背景を描画
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = PaintColors.outOfRangeBackground);

    // アートボードの絵画
    artBoardInfo.sizeRecalculation(size);

    canvas.drawRect(artBoardInfo.absolutePosition & artBoardInfo.size,
        Paint()..color = PaintColors.artBoardBackground);

    // 一画ごとに描画
    strokes.all.forEach((Stroke stroke) {
      var path = Path();

      if (stroke.points.length == 1) {
        final aPoint = stroke.points[0];
        final Offset anOffset = artBoardInfo.modelToOutput(aPoint);
        path.moveTo(anOffset.dx, anOffset.dy);
        path.lineTo(anOffset.dx, anOffset.dy);
      } else {
        stroke.points.asMap().forEach((int index, Offset aModelOffset) {
          final Offset anOutputOffset =
              artBoardInfo.modelToOutput(aModelOffset);

          if (index == 0) {
            path.moveTo(anOutputOffset.dx, anOutputOffset.dy);
          } else {
            path.lineTo(anOutputOffset.dx, anOutputOffset.dy);
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
