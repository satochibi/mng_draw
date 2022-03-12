import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mng_draw/screentone.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:mng_draw/fake_device_pixel_ratio_widget.dart';

class ScreentoneIcon extends StatefulWidget {
  final int index;
  const ScreentoneIcon({Key? key, required this.index}) : super(key: key);
  @override
  _ScreentoneIconState createState() => _ScreentoneIconState();
}

class _ScreentoneIconState extends State<ScreentoneIcon> {
  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);

    return FutureBuilder(
      future: Screentone.basicScreentones[widget.index].toImage(pen.color),
      builder: (context, snapshot) {
        return FakeDevicePixelRatio(
          fakeDevicePixelRatio: 1.0,
          child: GestureDetector(
            child: CustomPaint(
              painter: _SamplePainter(snapshot.data as ui.Image?),
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
  ui.Image? image;
  _SamplePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      final paint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill
        ..isAntiAlias = false
        ..shader = ImageShader(image!, TileMode.repeated, TileMode.repeated,
            Matrix4.identity().storage);
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_SamplePainter oldDelegate) {
    return true;
  }
}
