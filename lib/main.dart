import 'package:flutter/material.dart';
import 'dart:ui' as ui;

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
          title: const Text('Flutter Demo'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder(
            future: getPattern(),
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              return CustomPaint(
                painter: _SamplePainter(snapshot.data),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Future<ui.Image> getPattern() async {
  var pictureRecorder = ui.PictureRecorder();
  Canvas patternCanvas = Canvas(pictureRecorder);

  // Definition of checkered pattern
  List<Offset> points = const [
    //Depending on the environment, the Offset(0, 0) point of the pattern is not displayed.
    Offset(0, 0),
    Offset(1, 1),
  ];

  final patternPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = false;

  patternCanvas.drawPoints(ui.PointMode.points, points, patternPaint);
  final aPatternPicture = pictureRecorder.endRecording();

  return aPatternPicture.toImage(2, 2);
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
        ..color = Colors.blue
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
      canvas.drawImage(aPattern!, const Offset(50, 50), Paint());
    }
  }

  @override
  bool shouldRepaint(_SamplePainter oldDelegate) {
    return aPattern != oldDelegate.aPattern;
  }
}
