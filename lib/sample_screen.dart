import 'package:flutter/material.dart';
import 'package:mng_draw/art_board.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "MNGHub",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff68ca00),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // debugPrint("search");
                })
          ],
        ),
        drawer: Drawer(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text("Item $index"),
              );
            },
          ),
        ),
        body: SizedBox(
          height: 500,
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ArtBoard(
                    height: 192,
                    aspectRatioW: 4,
                    aspectRatioH: 3,
                    isDrawable: false,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
