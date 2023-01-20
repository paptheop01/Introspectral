import 'main.dart';
import 'journal.dart';
import 'calendar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';
import 'stats.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class PetShopWidget extends StatefulWidget {
  const PetShopWidget({Key? key}) : super(key: key);

  @override
  _PetShopWidgetState createState() => _PetShopWidgetState();
}

class _PetShopWidgetState extends State<PetShopWidget> {
  @override
  Widget thepetshop() {
    return GridView.count(
      crossAxisCount: 2,
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.asset(
              "assets/images/duck.png",
              width: 80,
              height: 80,
            ),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                // button 1 pressed
              },
            )
          ],
        ),
        Column(
          children: <Widget>[
            Image.asset(
              "assets/images/sroom.png",
              width: 80,
              height: 80,
            ),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                // button 2 pressed
              },
            )
          ],
        ),
        Column(
          children: <Widget>[
            Image.asset(
              "assets/images/fatdog.png",
              width: 80,
              height: 80,
            ),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                // button 3 pressed
              },
            )
          ],
        ),
        Column(
          children: <Widget>[
            Image.asset(
              "assets/images/yoshi.png",
              width: 80,
              height: 80,
            ),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                // button 4 pressed
              },
            )
          ],
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.1),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to PetShop'),
        ),
        body: Stack(children: <Widget>[
          Transform.translate(
            offset: Offset(0, 65),
            child: thepetshop(),
          ),
          //_buildLogList(),
        ]),
      ),
    );
  }
}
