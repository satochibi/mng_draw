import 'package:flutter/material.dart';
import 'package:mng_draw/widgets/art_board.dart';
import 'package:mng_draw/screens/choose_color_screen.dart';
import 'package:mng_draw/screens/choose_width_screen.dart';
import 'package:mng_draw/screens/choose_screentone_screen.dart';
import 'package:mng_draw/screens/choose_settings_screen.dart';

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
                TextButton(
                    child: const Text("settings"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("screentone scale"),
                              content: const ChooseSettingsScreen(),
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
            Expanded(
              child: ArtBoard(
                artBoardInfo: ArtBoardInfo(const Size(4, 3)),
                isDrawable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
