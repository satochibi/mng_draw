import 'package:flutter/material.dart';
import 'package:mng_draw/art_board.dart';
import 'package:mng_draw/choose_color_screen.dart';
import 'package:mng_draw/choose_width_screen.dart';
import 'package:mng_draw/choose_screentone_screen.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  child: const Text("color"),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text("choose a color!"),
                            content: ChooseColorScreen(),
                          );
                        });
                  },
                ),
                TextButton(
                    child: const Text("width"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("line width"),
                              content: const ChooseWidthScreen(),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK")),
                              ],
                            );
                          });
                    }),
                TextButton(
                    child: const Text("screentone"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("choose a screentone!"),
                              content: const ChooseScreentoneScreen(),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK")),
                              ],
                            );
                          });
                    }),
              ],
            ),
            const Expanded(child: ArtBoard()),
          ],
        ),
      ),
    );
  }
}
