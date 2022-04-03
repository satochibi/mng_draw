import 'package:flutter/material.dart';
import 'package:mng_draw/mng_memo.dart';
import 'package:mng_draw/mnghub_card_widget.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double cardHeight =
        (MediaQuery.of(context).size.width < 650) ? 105 : 192;

    debugPrint(MediaQuery.of(context).size.width.toString());

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
            width: double.infinity,
            child: ListView(children: [
              MNGHubCard(
                  height: cardHeight,
                  memo: MNGMemo(
                      "イーブイを描いてみた!",
                      "前に描いたものにいろいろ書き足してみました!動きはそのまんまですけどね。ところで、この作品を作るにあたって、どんなところ",
                      110489,
                      1121,
                      3334)),
              MNGHubCard(
                  height: cardHeight,
                  memo: MNGMemo("サンプルメモ", "サンプル", 10, 100, 1000)),
              MNGHubCard(
                  height: cardHeight,
                  memo: MNGMemo("棒人間", "ぼーにんげん", 1000, 10, 100)),
              MNGHubCard(
                  height: cardHeight,
                  memo: MNGMemo("棒人間", "ぼーにんげん", 1000, 10, 100)),
              MNGHubCard(
                  height: cardHeight,
                  memo: MNGMemo("棒人間", "ぼーにんげん", 1000, 10, 100)),
            ])));
  }
}
