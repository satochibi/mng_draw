import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// https://www.flutter-study.dev/widgets/button-widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: Container(
          width: 640,
          height: 480,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: Colors.blue,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage('https://placehold.jp/640x480.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('first line'),
              const Text('second line'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text('click here'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: const Text('click here'),
                  ),
                  ElevatedButton(
                    onPressed: () {/* ボタンがタップされた時の処理 */},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      elevation: 10,
                    ),
                    child: const Text('click here'),
                  ),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up),
                      label: const Text('Good'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite),
                      label: const Text('Like'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.flight),
                      label: const Text('Flight'),
                    )
                  ]),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
