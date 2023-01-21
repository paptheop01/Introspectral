import 'main.dart';
import 'journal.dart';
import 'calendar.dart';
import 'habit.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class PetShopWidget extends StatefulWidget {
  const PetShopWidget({Key? key}) : super(key: key);

  @override
  _PetShopWidgetState createState() => _PetShopWidgetState();
}

class _PetShopWidgetState extends State<PetShopWidget> {
  late int _scorecounter = 0;
  late List<bool> _myList = [false, false, false, false];

  void _loadScore() async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    setState(() {
      _scorecounter = prefs2.getInt('scorecounter') ?? 0;
    });
  }

  _saveMyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myList', _myList.toString());
  }

  _loadMyList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? myListString = prefs.getString('myList')?.split(",");
    if (myListString != null) {
      List<bool> myList =
          myListString.map((String value) => value == "true").toList();
      setState(() {
        _myList = myList;
      });
    }
  }

  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs2) {
      // Get the value of the counter variable from shared preferences
      setState(() {
        // _scorecounter = prefs2.getInt('scorecounter') ?? 0;
        _loadScore();
        // _loadMyList();
      });
    });
  }

  void _settozero(int points) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();

    setState(() {
      _scorecounter = 0;
      //_loadScore();
    });
    final scorecounter = await prefs2.setInt('scorecounter', _scorecounter);
  }

  void _buyPet(int points) async {
    SharedPreferences prefs2 = await SharedPreferences.getInstance();

    setState(() {
      _scorecounter -= points;
      //_loadScore();
    });
    final scorecounter = await prefs2.setInt('scorecounter', _scorecounter);
  }

  _noMoney() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Oh No!'),
            content: Text("You don't have enough points"),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _buyPetPopup(int points, int index) async {
    // Buy pet pop up window

    bool buypet = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Buy Pet'),
            content: Text('Are you sure you want to purchase this pet?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });

    if (buypet && _scorecounter >= points) {
      _buyPet(points);
      setState(() {
        _myList[index] = true;
        //  _saveMyList();
      });
    } else if (buypet && _scorecounter < points) {
      _noMoney();
    }
    setState(() {
      _loadScore();
    });
  }

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
            Text('500',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: !_myList[0] ? Text('Buy') : Text('Select'),
              onPressed: () {
                if (!_myList[0]) {
                  _buyPetPopup(50, 0);
                }
                // _settozero(0);
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
            Text('1500',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                _buyPetPopup(150, 1);
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
            Text('5000',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                _buyPetPopup(5000, 2);
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
            Text('15000',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: Text("Buy"),
              onPressed: () {
                _buyPetPopup(15000, 3);
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
          Transform.translate(
            offset: Offset(0, 165),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                  'You currently have ' + _scorecounter.toString() + ' points',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                    // fontWeight: FontWeight.bold,
                  )),
            ),
          ),
        ]),
      ),
    );
  }
}
