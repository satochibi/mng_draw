import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:mng_draw/paint_patterns.dart' as patterns;
import 'package:mng_draw/paint_colors.dart' as colors;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PictureRecorder Test'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder(
            future: getPattern(),
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              return FakeDevicePixelRatio(
                fakeDevicePixelRatio: 1.0,
                child: CustomPaint(
                  painter: _SamplePainter(snapshot.data),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<ui.Image> getPattern() async {
  var aPattern = patterns.checkered();
  var aColor = colors.blue();

  var aPatternPosition = aPattern["data"] as List<Offset>;
  var width = aPattern["width"] as int;
  var height = aPattern["height"] as int;

  var aNextPatternPosition =
      aPatternPosition.map((e) => e + Offset(width.toDouble(), 0)).toList();

  var aPaint = Paint()
    ..color = aColor
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
  final ui.Image? aPattern;

  _SamplePainter(this.aPattern);

  @override
  void paint(Canvas canvas, Size size) {
    if (aPattern != null) {
      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..isAntiAlias = false
        ..shader = ImageShader(aPattern!, TileMode.repeated, TileMode.repeated,
            Matrix4.identity().storage);

      var path = Path();
      path.moveTo(size.width / 2, size.height / 5);
      path.lineTo(size.width / 4, size.height / 5 * 4);
      path.lineTo(size.width / 4 * 3, size.height / 5 * 4);
      path.close();

      canvas.drawPath(path, paint);

      //Depending on the environment, the Offset(0, 0) point of the pattern is not displayed.
      // canvas.drawImage(
      //     aPattern!, Offset(size.width / 2, size.height / 2), Paint());
    }
  }

  @override
  bool shouldRepaint(_SamplePainter oldDelegate) {
    return aPattern != oldDelegate.aPattern;
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
