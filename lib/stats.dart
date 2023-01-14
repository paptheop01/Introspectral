import 'main.dart';
import 'journal.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class StatsScreenWidget extends StatefulWidget {
  const StatsScreenWidget({Key? key}) : super(key: key);

  @override
  _StatsScreenWidgetState createState() => _StatsScreenWidgetState();
}

class _StatsScreenWidgetState extends State<StatsScreenWidget> {
  @override
  late SQLservice sqLiteservice;
  int _lifemood = 0;

  void initState() {
    super.initState();
    sqLiteservice = SQLservice();
    sqLiteservice.initDB().whenComplete(() async {
      final lifemood = await sqLiteservice.lifeMood();
      setState(() {
        _lifemood = lifemood;
      });
    });
  }

  String _getEmotionPath(int emotionID) {
    switch (emotionID) {
      case 0:
        return 'assets/images/angry.png';
      case 1:
        return 'assets/images/annoyed.png';
      case 2:
        return 'assets/images/ashamed.png';
      case 3:
        return 'assets/images/bored.png';
      case 4:
        return 'assets/images/confused.png';
      case 5:
        return 'assets/images/content.png';
      case 6:
        return 'assets/images/curious.png';
      case 7:
        return 'assets/images/unkempt.png';
      case 8:
        return 'assets/images/energetic.png';
      default:
        return 'assets/images/angry.png';
    }
  }

  Widget _buildLifeMood() {
    return Image.asset(
      _getEmotionPath(_lifemood),
      width: 42,
      height: 42,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(45),
              child: Text(
                'Stats',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 36,
                ),
              ),
            ),
          ),
          Positioned(
            top: 85,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(45),
              child: Text(
                'Lifetime Mood:',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Positioned(
            top: 118,
            right: 100,
            child: Image.asset(
              _getEmotionPath(_lifemood),
              width: 42,
              height: 42,
            ),
          ),
        ],
      ),
    );
  }
}
