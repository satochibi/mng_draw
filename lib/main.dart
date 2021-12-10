import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// https://www.flutter-study.dev/widgets/container-widget
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
          width: 200,
          height: 300,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: Colors.blue,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: NetworkImage('https://placehold.jp/200x300.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: const Text('Blue'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
