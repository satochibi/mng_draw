import 'package:flutter/material.dart';

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
        body: Container(
          color: Colors.blue,
          child: Container(
            color: Colors.red,
            width: 256,
            height: 192,
          ),
        ));
  }
}
