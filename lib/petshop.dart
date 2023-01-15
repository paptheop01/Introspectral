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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 202, 212, 211),
      appBar: AppBar(
        title: const Text('Welcome to PetShop'),
      ),
      body: Stack(children: <Widget>[
        Container(),
        //_buildLogList(),
      ]),
    );
  }
}
