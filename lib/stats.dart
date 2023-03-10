import 'main.dart';
import 'journal.dart';
import 'habit.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:introspectral/logmap.dart';
import 'package:introspectral/petshop.dart';

class StatsScreenWidget extends StatefulWidget {
  const StatsScreenWidget({Key? key}) : super(key: key);

  @override
  _StatsScreenWidgetState createState() => _StatsScreenWidgetState();
}

class _StatsScreenWidgetState extends State<StatsScreenWidget>
    with SingleTickerProviderStateMixin {
  @override
  late SQLservice sqLiteservice;
  List<Map<dynamic, dynamic>> _lifemood = [];
  int _weekmood = 0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late int _scorecounter = 0;
  // nothing yet perimenoume google maps
  void _logmap() async {
    String? logmap = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MapLogWidget()));

    if (logmap != null) {
      setState(() {});
    }
  }

  // kanei navigate sto petshop page
  void _petshop() async {
    String? petshop = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PetShopWidget()));

    if (petshop != null) {
      setState(() {});
    }
  }

  // enhmerwnei timi ton points
  void _loadScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _scorecounter = prefs.getInt('scorecounter') ?? 0;
    });
  }

  // init
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _offsetAnimation = TweenSequence([
      TweenSequenceItem<Offset>(
        tween: Tween<Offset>(
          begin: Offset(0, 0),
          end: Offset(0, 5),
        ),
        weight: 1,
      ),
      TweenSequenceItem<Offset>(
        tween: Tween<Offset>(
          begin: Offset(0, 5),
          end: Offset(0, 0),
        ),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();

    sqLiteservice = SQLservice();
    sqLiteservice.initDB().whenComplete(() async {
      final lifemood = await sqLiteservice.lifeMood();
      final weekmood = await sqLiteservice.weekMood();

      setState(() {
        _lifemood = lifemood;
        _weekmood = weekmood;
        _loadScore();
      });
    });
/*
    SharedPreferences.getInstance().then((prefs) {
      // Get the value of the counter variable from shared preferences
      setState(() {
        _scorecounter = prefs.getInt('scorecounter') ?? 0;
      });
    });*/
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //  _scorecounter = prefs.getInt('scorecounter') ?? 0;
      _loadScore();
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

  Widget _buildLifeMood(int lmood) {
    return Image.asset(
      _getEmotionPath(lmood),
      width: 42,
      height: 42,
    );
  }

  Widget _buildAnimMood(BuildContext context, int lmood) {
    if (lmood == -1)
      return Text('');
    else
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _offsetAnimation.value,
            child: Image.asset(
              _getEmotionPath(lmood),
            ),
          );
        },
      );
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
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
                'Lifetime Moods:',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Positioned(
            top: 118,
            left: 220,
            child: _buildAnimMood(
                context, _lifemood.isEmpty ? -1 : _lifemood[0]['emotionID']),
            width: 42,
            height: 42,
          ),
          Positioned(
            top: 118,
            left: 270,
            child: _buildAnimMood(context,
                (_lifemood.length < 2) ? -1 : _lifemood[1]['emotionID']),
            width: 42,
            height: 42,
          ),
          Positioned(
            top: 118,
            left: 320,
            child: _buildAnimMood(context,
                (_lifemood.length < 3) ? -1 : _lifemood[2]['emotionID']),
            width: 42,
            height: 42,
          ),
          Positioned(
            top: 155,
            left: 20,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(45),
              child: Text(
                'Weekly Mood:',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Positioned(
            top: 185,
            left: 220,
            child: _buildAnimMood(context, _weekmood),
            width: 42,
            height: 42,
          ),
          Transform.translate(
            offset: Offset(0, 255),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: <Widget>[
                  Container(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Trip Down Memory Map    "),
                          Icon(Icons.map)
                        ],
                      ),
                      onPressed: () {
                        _logmap();
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text('So far you have collected',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )),
                  ),
                  SizedBox(height: 10),
                  Image.asset(
                    'assets/images/bulls.png',
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(height: 10),
                  Text(_scorecounter.toString() + ' points',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255),
                      )),
                  SizedBox(height: 10),
                  Container(
                    child: ElevatedButton(
                      child: Text("Pet Shop!"),
                      onPressed: () {
                        setState(() {
                          _loadScore();
                        });
                        _petshop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
