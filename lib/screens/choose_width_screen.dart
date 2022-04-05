import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/models/pen_model.dart';

class ChooseWidthScreen extends StatelessWidget {
  const ChooseWidthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: Slider(
        label: '${pen.width.round()}',
        min: 1,
        max: 50,
        value: pen.width,
        activeColor: Colors.orange,
        inactiveColor: Colors.blueAccent,
        divisions: 49,
        onChanged: (double value) {
          pen.width = value.roundToDouble();
        },
      ),
    );
  }
}
