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
            width: double.infinity,
            child: ListView(children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: ArtBoard(
                        height: 105,
                        aspectRatioW: 4,
                        aspectRatioH: 3,
                        isDrawable: true,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 10, right: 10, bottom: 10),
                        child: SizedBox(
                          height: 105,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: const [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "イーブイを描いてみた",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "前に描いたものにいろいろ書き足してみました。動きはそのまんまですけどね。ところで、この作品を作るにあたって、どんなところ",
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    color: const Color(0xffeeeeee),
                                    width: double.infinity,
                                    height: 14,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          child: Container(
                                            width: 22,
                                            color: const Color(0xffcfcfcf),
                                            child: const FittedBox(
                                              child: Icon(Icons.play_arrow,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "110,489",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff777777)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: const Color(0xffffeeb9),
                                    width: double.infinity,
                                    height: 14,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          child: Container(
                                            width: 22,
                                            color: const Color(0xffffa600),
                                            child: const FittedBox(
                                              child: Icon(Icons.star,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "1,121",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfff58206)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      color: const Color(0xffdcf1ff),
                                      width: double.infinity,
                                      height: 14,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              child: Container(
                                                width: 22,
                                                color: const Color(0xff2693FF),
                                                child: const FittedBox(
                                                  child: Icon(Icons.download,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            const FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "3,334",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff2984e2)),
                                              ),
                                            ),
                                          ])),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
