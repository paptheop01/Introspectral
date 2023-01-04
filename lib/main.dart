// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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