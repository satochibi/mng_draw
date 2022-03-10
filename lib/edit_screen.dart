import 'package:flutter/material.dart';
import 'package:mng_draw/art_board.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ArtBoard(),
      ),
    );
  }
}
