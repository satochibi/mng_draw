import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/classes/paint_colors.dart';
import 'package:mng_draw/classes/screentone.dart';
import 'package:mng_draw/models/pen_model.dart';
import 'package:mng_draw/components/screentone_icon.dart';

class ChooseScreentoneScreen extends StatelessWidget {
  const ChooseScreentoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);
    return Container(
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
                Navigator.of(context).pop();
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
    );
  }
}
