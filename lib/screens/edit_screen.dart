import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mng_draw/models/strokes_model.dart';
import 'package:mng_draw/models/settings_model.dart';
import 'package:mng_draw/widgets/art_board.dart';
import 'package:mng_draw/screens/choose_pen_screen.dart';
import 'package:mng_draw/screens/choose_settings_screen.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);
    final strokes = Provider.of<StrokesModel>(context);
    final artBoardKey = GlobalObjectKey<ArtBoardState>(context);

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
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("pen settings"),
                              content: const ChoosePenScreen(),
                              actions: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK")),
                                )
                              ],
                            );
                          });
                    },
                  ),
                  const IconButton(
                    icon: FaIcon(FontAwesomeIcons.eraser),
                    color: Colors.blue,
                    onPressed: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.undo),
                    color: Colors.blue,
                    onPressed:
                        strokes.isEmpty ? null : () => strokes.removeLast(),
                  ),
                  const IconButton(
                    icon: Icon(Icons.redo),
                    color: Colors.blue,
                    onPressed: null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.blue,
                    onPressed: strokes.isEmpty ? null : () => strokes.clear(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen),
                    color: Colors.blue,
                    onPressed: () => artBoardKey.currentState?.fullscreen(),
                  ),
                  IconButton(
                      icon: const Icon(Icons.settings),
                      color: Colors.blue,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("system settings"),
                                content: const ChooseSettingsScreen(),
                                actions: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK")),
                                  ),
                                ],
                              );
                            });
                      }),
                ],
              ),
            ),
            Expanded(
              child: ArtBoard(
                key: artBoardKey,
                width: double.infinity,
                height: double.infinity,
                aspectRatio: const Size(4, 3),
                isDrawable: true,
                isClip: settings.isClip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
