import 'package:flutter/material.dart';
import 'package:mng_draw/art_board.dart';
import 'package:mng_draw/pen_model.dart';
import 'package:provider/provider.dart';
import 'package:mng_draw/paint_colors.dart' as colors;

class EditScreen extends StatelessWidget {
  EditScreen({Key? key}) : super(key: key);

  final colorList = [
    colors.black(),
    colors.blue(),
    colors.green(),
    colors.red(),
    colors.white(),
    colors.yellow(),
  ];

  @override
  Widget build(BuildContext context) {
    final pen = Provider.of<PenModel>(context);

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: <Widget>[
                              TextButton(
                                child: Text('black'),
                                onPressed: () {
                                  pen.color = colors.black();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('blue'),
                                onPressed: () {
                                  pen.color = colors.blue();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("color")),
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
