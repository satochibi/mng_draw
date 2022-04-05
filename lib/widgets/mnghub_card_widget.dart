import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mng_draw/classes/mng_memo.dart';
import 'package:mng_draw/widgets/art_board.dart';

class MNGHubCard extends StatelessWidget {
  final MNGMemo memo;
  final double height;
  const MNGHubCard({Key? key, required this.height, required this.memo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => debugPrint("memo: ${memo.title}"),
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: ArtBoard(
                height: height,
                artBoardInfo: ArtBoardInfo(const Size(4, 3)),
                isDrawable: false,
              ),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
                child: SizedBox(
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              memo.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ((height - 14 * 3) * 1 / 6)
                                      .ceilToDouble()),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              memo.description,
                              style: TextStyle(
                                  fontSize: ((height - 14 * 3) * 1 / 7)
                                          .ceilToDouble() +
                                      1),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                    width: 22,
                                    color: const Color(0xffcfcfcf),
                                    child: const FittedBox(
                                      child: Icon(Icons.play_arrow,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    NumberFormat("#,###")
                                        .format(memo.playCount),
                                    style: const TextStyle(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Container(
                                    width: 22,
                                    color: const Color(0xffffa600),
                                    child: const FittedBox(
                                      child:
                                          Icon(Icons.star, color: Colors.white),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    NumberFormat("#,###")
                                        .format(memo.starCount),
                                    style: const TextStyle(
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
                                      borderRadius: BorderRadius.circular(3),
                                      child: Container(
                                        width: 22,
                                        color: const Color(0xff2693FF),
                                        child: const FittedBox(
                                          child: Icon(Icons.download,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        NumberFormat("#,###")
                                            .format(memo.downloadCount),
                                        style: const TextStyle(
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
    );
  }
}
