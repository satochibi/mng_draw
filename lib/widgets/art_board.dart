import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:mng_draw/classes/paint_colors.dart';
import 'package:mng_draw/models/settings_model.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/models/strokes_model.dart';
import 'package:mng_draw/models/achievement_model.dart';
import 'package:mng_draw/widgets/fake_device_pixel_ratio_widget.dart';

class ArtBoardInfo {
  final Size aspectRatio;
  int scaleFactor = 1;
  // アートボードの左上座標
  Offset defaultAbsolutePosition = Offset.zero;
  // アートボードの大きさ
  Size defalutSize = Size.zero;
  bool isClip;
  // デフォルトからの位置の変位(変化時)
  Offset deltaPosition = Offset.zero;
  // 行列
  List<Matrix4> matrixes = [];

  ArtBoardInfo(this.aspectRatio, this.isClip);

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

    defaultAbsolutePosition = Offset(artBoardRect.left, artBoardRect.top);
    defalutSize = Size((artBoardRect.right - artBoardRect.left).abs(),
        (artBoardRect.bottom - artBoardRect.top).abs());

    defaultAbsolutePosition += deltaPosition;

    if (matrixes.isNotEmpty) {
      final matrix = matrixes.reduce((total, element) => total * element);
      defaultAbsolutePosition =
          vector3ToOffset(matrix * offsetToVector3(defaultAbsolutePosition));
    }
  }

  Matrix4 matrixToAspectCoordinates() {
    Matrix4 A = Matrix4.translationValues(
        -defaultAbsolutePosition.dx, -defaultAbsolutePosition.dy, 0);
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

enum TouchEvent { down, moved }

class ArtBoard extends StatefulWidget {
  double? height;
  double? width;
  final Size aspectRatio;
  final bool isDrawable;
  final bool isClip;

  ArtBoard(
      {Key? key,
      this.width,
      this.height,
      required this.aspectRatio,
      required this.isDrawable,
      required this.isClip})
      : super(key: key) {
    if (width == null) {
      if (height != null) {
        width = aspectRatio.width * (height! / aspectRatio.height);
      }
    } else if (height == null) {
      if (width != null) {
        height = aspectRatio.height * (width! / aspectRatio.width);
      }
    }
  }

  @override
  State<ArtBoard> createState() => ArtBoardState();
}

class ArtBoardState extends State<ArtBoard> {
  ArtBoardInfo artBoardInfo = ArtBoardInfo(const Size(1, 1), true);
  Offset? prevPositionOfPen;
  Offset? velocityOfPen;

  @override
  void initState() {
    super.initState();
    artBoardInfo = ArtBoardInfo(widget.aspectRatio, widget.isClip);
  }

  void fullscreen() {
    setState(() {
      artBoardInfo.matrixes.clear();
    });
  }

  void achievementCalculation(
      AchievementModel achievement, Offset pos, TouchEvent e) {
    switch (e) {
      case TouchEvent.down:
        prevPositionOfPen = null;
        velocityOfPen = null;
        achievement.totalDistanceOfPenRun += 1;
        achievement.totalNumberOfPenStrokes += 1;
        break;
      case TouchEvent.moved:
        velocityOfPen = (pos - prevPositionOfPen!);
        achievement.totalDistanceOfPenRun +=
            achievement.distance(pos, prevPositionOfPen!);
        break;
    }
    // debugPrint("ペンを走らせた距離: ${achievement.totalDistanceOfPenRun}px");
    // debugPrint("ペンを走らせた回数: ${achievement.totalNumberOfPenStrokes}");
    prevPositionOfPen = pos;
  }

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    final strokes = Provider.of<StrokesModel>(context);
    final settings = Provider.of<SettingsModel>(context);
    final achievement = Provider.of<AchievementModel>(context);
    final repaint = ChangeNotifier();
    artBoardInfo.isClip = settings.isClip;

    return FutureBuilder(
        future: strokes.screentoneImage(),
        builder: (context, snapshot) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: FakeDevicePixelRatio(
              fakeDevicePixelRatio: 1.0,
              child: GestureDetector(
                onScaleStart: (details) {
                  if (widget.isDrawable) {
                    if (details.pointerCount == 1) {
                      final pos = details.localFocalPoint;
                      strokes.add(settings, pen, artBoardInfo.scaleFactor,
                          artBoardInfo.inputToModel(pos));
                      achievementCalculation(achievement, pos, TouchEvent.down);
                    }
                  }
                },
                onScaleUpdate: (details) {
                  if (widget.isDrawable) {
                    if (details.pointerCount == 1) {
                      final pos = details.localFocalPoint;
                      strokes.update(artBoardInfo.inputToModel(pos));
                      achievementCalculation(
                          achievement, pos, TouchEvent.moved);
                    } else if (details.pointerCount >= 2) {
                      final pos = details.localFocalPoint;
                      final posDelta = details.focalPointDelta;
                      final scale = details.scale;
                      final rotation = details.rotation;
                      artBoardInfo.deltaPosition += posDelta;
                      repaint.notifyListeners();
                    }
                  }
                },
                onScaleEnd: (details) {
                  artBoardInfo.matrixes.add(Matrix4.translation(artBoardInfo
                      .offsetToVector3(artBoardInfo.deltaPosition)));
                  artBoardInfo.deltaPosition = Offset.zero;
                  repaint.notifyListeners();
                },
                child: ClipRect(
                  child: CustomPaint(
                    painter: _SamplePainter(repaint, artBoardInfo, strokes),
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

  _SamplePainter(Listenable repaint, this.artBoardInfo, this.strokes)
      : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size surfaceSize) {
    // 背景を描画
    if (!artBoardInfo.isClip) {
      canvas.drawRect(
          Rect.fromLTWH(0, 0, surfaceSize.width, surfaceSize.height),
          Paint()..color = PaintColors.outOfRangeBackground);
    }

    // アートボードの絵画
    artBoardInfo.sizeRecalculation(surfaceSize);

    canvas.drawRect(
        artBoardInfo.defaultAbsolutePosition & artBoardInfo.defalutSize,
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
        ..strokeWidth = (artBoardInfo.scaleFactor *
                stroke.width /
                stroke.artBoardScaleFactor)
            .ceilToDouble()
        ..isAntiAlias = false
        ..color = stroke.color;

      // スクリーントーンを生成したら、そのシェーダを作ってペイント
      if (stroke.screentoneImage != null) {
        paint = Paint()
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = (artBoardInfo.scaleFactor *
                  stroke.width /
                  stroke.artBoardScaleFactor)
              .ceilToDouble()
          ..isAntiAlias = false
          ..shader = ImageShader(stroke.screentoneImage as ui.Image,
              TileMode.repeated, TileMode.repeated, Matrix4.identity().storage);
      }

      canvas.drawPath(path, paint);
    });

    // アートボード範囲でクリッピング
    if (artBoardInfo.isClip) {
      canvas.drawPath(
          Path.combine(
              PathOperation.difference,
              Path()
                ..addRect(
                    Rect.fromLTWH(0, 0, surfaceSize.width, surfaceSize.height)),
              Path()
                ..addRect(Rect.fromLTWH(
                    artBoardInfo.defaultAbsolutePosition.dx,
                    artBoardInfo.defaultAbsolutePosition.dy,
                    artBoardInfo.defalutSize.width,
                    artBoardInfo.defalutSize.height))),
          Paint()
            ..color = PaintColors.outOfRangeBackground
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(_SamplePainter oldDelegate) {
    return true;
  }
}
