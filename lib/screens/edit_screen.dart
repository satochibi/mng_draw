import 'package:flutter/material.dart';
import 'package:mng_draw/widgets/art_board.dart';
import 'package:mng_draw/screens/choose_pen_screen.dart';
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
            SizedBox(
              width: double.infinity,
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  TextButton(
                    child: const Text("pen"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("pen settings"),
                              content: const ChoosePenScreen(),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"))
                              ],
                            );
                          });
                    },
                  ),
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
            ),
            Expanded(
              child: ArtBoard(
                artBoardInfo: ArtBoardInfo(const Size(4, 3), false),
                isDrawable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
