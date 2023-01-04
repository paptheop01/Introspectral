// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/box_decoration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Introspectral',
      theme: ThemeData(
        canvasColor: Color.fromARGB(255, 241, 186, 255),
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreenWidget(),
    );
  }
}


class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key?key}) : super(key:key);

  
  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}


class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    body: new Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(image: new AssetImage("assets/images/back.png"), fit: BoxFit.cover,),
          ),
        ),
        new Center(
          child: new Text("Hello background"),
        )
      ],
    )
  );
}


}