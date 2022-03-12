import 'package:flutter/material.dart';
import 'package:mng_draw/art_board.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/paint_colors.dart';

class EditScreen extends StatelessWidget {
  EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                child: Text("color"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("choose a color!"),
                          actions: <Widget>[
                            SizedBox(
                              height: 80,
                              width: 290,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: PaintColors.basicColors.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        pen.color =
                                            PaintColors.basicColors[index];
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(3),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          color: PaintColors.basicColors[index],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        );
                      });
                },
              ),
              TextButton(onPressed: null, child: Text("width")),
              TextButton(onPressed: null, child: Text("screentone")),
            ],
          ),
          const Expanded(child: ArtBoard()),
        ],
      ),
    );
  }
}
