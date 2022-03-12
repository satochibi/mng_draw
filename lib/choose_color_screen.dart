import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/paint_colors.dart';
import 'package:mng_draw/pen_model.dart';

class ChooseColorScreen extends StatelessWidget {
  const ChooseColorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: PaintColors.basicColors.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                pen.color = PaintColors.basicColors[index];
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.all(3),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: PaintColors.basicColors[index],
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
    );
  }
}
