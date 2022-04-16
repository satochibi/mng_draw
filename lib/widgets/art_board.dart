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
  Map<String, Offset> defaultAbsolutePosition = {
    'left-top': Offset.zero,
    'right-top': Offset.zero,
    'left-bottom': Offset.zero,
    'right-bottom': Offset.zero,
  };

  // アートボードの大きさ
  Size defalutSize = Size.zero;
  bool isClip;
  // デフォルトからの位置の変位(変化時)
  Matrix4 matrixInProgress = Matrix4.identity();
  // 完了した行列
  List<Matrix4> completedMatrixes = [Matrix4.identity()];

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

    defaultAbsolutePosition['left-top'] =
        Offset(artBoardRect.left, artBoardRect.top);
    defalutSize = Size((artBoardRect.right - artBoardRect.left).abs(),
        (artBoardRect.bottom - artBoardRect.top).abs());
    defaultAbsolutePosition['right-top'] =
        defaultAbsolutePosition['left-top']! + Offset(defalutSize.width, 0);
    defaultAbsolutePosition['left-bottom'] =
        defaultAbsolutePosition['left-top']! + Offset(0, defalutSize.height);
    defaultAbsolutePosition['right-bottom'] =
        defaultAbsolutePosition['left-top']! +
            Offset(defalutSize.width, defalutSize.height);

    // 行列が確定したものたちで変換
    defaultAbsolutePosition = defaultAbsolutePosition.map((key, value) =>
        MapEntry(
            key,
            vector3ToOffset(getCompleteMatrixes() *
                matrixInProgress *
                offsetToVector3(value))));
  }

  getCompleteMatrixes() {
    final matrix =
        completedMatrixes.reduce((total, element) => total * element);
    completedMatrixes.clear();
    completedMatrixes.add(matrix);
    return matrix;
  }

  completedMatrixesAdd() {
    completedMatrixes.add(matrixInProgress);
    final matrix = getCompleteMatrixes();
    completedMatrixes.clear();
    completedMatrixes.add(matrix);
    matrixInProgress = Matrix4.identity();
  }

  Matrix4 matrixRotationAroundPivot(Offset pivot, double radians) {
    final Matrix4 translation1 = Matrix4.translation(offsetToVector3(pivot));
    final Matrix4 translation2 =
        Matrix4.translation(offsetToVector3(pivot.scale(-1, -1)));
    final Matrix4 rotation = Matrix4.rotationZ(radians);
    return translation1 * rotation * translation2;
  }

  Matrix4 matrixScaleAroundPivot(Offset pivot, double scaleFactor) {
    final Matrix4 translation1 = Matrix4.translation(offsetToVector3(pivot));
    final Matrix4 translation2 =
        Matrix4.translation(offsetToVector3(pivot.scale(-1, -1)));
    final Matrix4 scale = Matrix4.diagonal3(Vector3.all(scaleFactor));
    return translation1 * scale * translation2;
  }

  Matrix4 matrixToAspectCoordinates() {
    Matrix4 translation = Matrix4.identity();
    if (matrixInProgress != Matrix4.identity()) {
      // progress中に表示が崩れる
      translation *= Matrix4.inverted(getCompleteMatrixes());
      translation *= Matrix4.inverted(matrixInProgress);
    } else {
      translation *= Matrix4.inverted(getCompleteMatrixes());
    }
    final Matrix4 scale = Matrix4.diagonal3(Vector3.all(1.0 / scaleFactor));
    return scale * translation;
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
  Offset posOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    artBoardInfo = ArtBoardInfo(widget.aspectRatio, widget.isClip);
  }

  void fullscreen() {
    setState(() {
      artBoardInfo.completedMatrixes.clear();
      artBoardInfo.completedMatrixes.add(Matrix4.identity());
      artBoardInfo.matrixInProgress = Matrix4.identity();
      posOffset = Offset.zero;
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
                      posOffset += posDelta;
                      // artBoardInfo.matrixInProgress = Matrix4.translation(
                      //     artBoardInfo.offsetToVector3(posOffset));
                      artBoardInfo.matrixInProgress =
                          artBoardInfo.matrixScaleAroundPivot(pos, scale);

                      repaint.notifyListeners();
                    }
                  }
                },
                onScaleEnd: (details) {
                  artBoardInfo.completedMatrixesAdd();
                  posOffset = Offset.zero;
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
        Rect.fromLTRB(
            artBoardInfo.defaultAbsolutePosition['left-top']!.dx,
            artBoardInfo.defaultAbsolutePosition['left-top']!.dy,
            artBoardInfo.defaultAbsolutePosition['right-bottom']!.dx,
            artBoardInfo.defaultAbsolutePosition['right-bottom']!.dy),
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
                ..addRect(Rect.fromLTRB(
                    artBoardInfo.defaultAbsolutePosition['left-top']!.dx,
                    artBoardInfo.defaultAbsolutePosition['left-top']!.dy,
                    artBoardInfo.defaultAbsolutePosition['right-bottom']!.dx,
                    artBoardInfo.defaultAbsolutePosition['right-bottom']!.dy))),
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
