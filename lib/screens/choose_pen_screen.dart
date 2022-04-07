import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/classes/paint_colors.dart';
import 'package:mng_draw/classes/screentone.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/components/screentone_icon.dart';

class ChoosePenScreen extends StatelessWidget {
  const ChoosePenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    return SizedBox(
      width: double.maxFinite,
      height: 300,
      child: ListView(children: [
        SizedBox(
          height: 50,
          width: double.maxFinite,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: PaintColors.basicColors.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    pen.color = PaintColors.basicColors[index];
                    // Navigator.of(context).pop();
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      margin: const EdgeInsets.all(3),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: PaintColors.basicColors[index],
                        shape: BoxShape.circle,
                      ),
                    ),
                    (PaintColors.basicColors[index] == pen.color)
                        ? const Icon(
                            Icons.check,
                            color: PaintColors.lasso,
                            size: 30,
                          )
                        : Container()
                  ]),
                );
              }),
        ),
        SizedBox(
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
        ),
        Container(
          color: PaintColors.artBoardBackground,
          height: 200,
          width: double.maxFinite,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
              ),
              itemCount: Screentone.basicScreentones.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    pen.screentone = Screentone.basicScreentones[index];
                    // Navigator.of(context).pop();
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: ScreentoneIcon(
                        index: index,
                      ),
                    ),
                    (Screentone.basicScreentones[index] == pen.screentone)
                        ? const Icon(
                            Icons.check,
                            color: PaintColors.lasso,
                            size: 50,
                          )
                        : Container()
                  ]),
                );
              }),
        )
      ]),
    );
  }
}
