import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mng_draw/models/settings_model.dart';
import 'package:mng_draw/widgets/art_board.dart';
import 'package:mng_draw/screens/choose_pen_screen.dart';
import 'package:mng_draw/screens/choose_settings_screen.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsModel>(context);

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
                      icon: FaIcon(FontAwesomeIcons.eraser), onPressed: null),
                  const IconButton(icon: Icon(Icons.undo), onPressed: null),
                  const IconButton(icon: Icon(Icons.redo), onPressed: null),
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
                artBoardInfo: ArtBoardInfo(const Size(4, 3), settings.isClip),
                isDrawable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
