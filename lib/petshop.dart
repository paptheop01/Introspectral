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
import 'dart:convert';

class PetShopWidget extends StatefulWidget {
  const PetShopWidget({Key? key}) : super(key: key);

  @override
  _PetShopWidgetState createState() => _PetShopWidgetState();
}

class _PetShopWidgetState extends State<PetShopWidget> {
  late int _scorecounter = 0;
  int _selectedpet = 0;
  int _button = 0;
  int _button1 = 0;
  int _button2 = 0;
  int _button3 = 0;

  _loadSelectedPet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final selectedpet = prefs.getInt('selpet');
    if (selectedpet != null) {
      setState(() {
        _selectedpet = selectedpet;
      });
    }
  }

  void _saveSelectedPet(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedpet = value;
    });
    final selectedpet = await prefs.setInt('selpet', _selectedpet);
  }

  _loadButton() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final buttonvalue = prefs.getInt('button');
    if (buttonvalue != null) {
      setState(() {
        _button = buttonvalue;
      });
    }
    final buttonvalue1 = prefs.getInt('button1');
    if (buttonvalue1 != null) {
      setState(() {
        _button1 = buttonvalue1;
      });
    }
    final buttonvalue2 = prefs.getInt('button2');
    if (buttonvalue2 != null) {
      setState(() {
        _button2 = buttonvalue2;
      });
    }
    final buttonvalue3 = prefs.getInt('button3');
    if (buttonvalue3 != null) {
      setState(() {
        _button3 = buttonvalue3;
      });
    }
  }

  void _saveButton0(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _button = value;
    });
    final button = await prefs.setInt('button', _button);
  }

  void _saveButton1(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _button1 = value;
    });
    final button1 = await prefs.setInt('button1', _button1);
  }

  void _saveButton2(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _button2 = value;
    });
    final button2 = await prefs.setInt('button2', _button2);
  }

  void _saveButton3(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _button3 = value;
    });
    final button3 = await prefs.setInt('button3', _button3);
  }

  void _loadScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _scorecounter = prefs.getInt('scorecounter') ?? 0;
    });
  }

  _youhaveselected(String thepet) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            backgroundColor: Color(0xFF83B7B5),
            title: Text('Nice Pet!'),
            content: Text("You just selected " + thepet + " to be your pet!",
                textAlign: TextAlign.center),
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

/*
  void _loadMyList() async {
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

  void _saveMyList(bool value, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myList', _myList.toString());
  }
*/
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      // Get the value of the counter variable from shared preferences
      setState(() {
        _loadScore();
        _loadButton();
        _loadSelectedPet();
        // initialize xeirokinita ta pets an thes

        // _saveButton0(0);
        //  _saveButton1(0);
        // _saveButton2(0);
        //  _saveButton3(0);
      });
    });
  }

  void _settozero(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _scorecounter = 0;
      //_loadScore();
    });
    final scorecounter = await prefs.setInt('scorecounter', _scorecounter);
  }

  void _buyPet(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _scorecounter -= points;
      _loadScore();
    });
    final scorecounter = await prefs.setInt('scorecounter', _scorecounter);
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
      if (index == 0) _saveButton0(1);
      if (index == 1) _saveButton1(1);
      if (index == 2) _saveButton2(1);
      if (index == 3) _saveButton3(1);
    } else if (buypet && _scorecounter < points) {
      _noMoney();
    }
    setState(() {
      _loadScore();
    });
  }

  String _getPetPath(int petID) {
    switch (petID) {
      case 0:
        return 'assets/images/duck.png';
      case 1:
        return 'assets/images/sroom.png';
      case 2:
        return 'assets/images/fatdog.png';
      case 3:
        return 'assets/images/yoshi.png';
    }
    return '';
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
            Text('10',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: (_button == 0) ? Text('Buy') : Text('Select'),
              onPressed: () {
                if (_button == 0) {
                  _buyPetPopup(10, 0);
                  // _saveButton0(1);
                }
                if (_button == 1) {
                  _youhaveselected('the duck');
                  _saveSelectedPet(0);
                }
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
            Text('25',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: (_button1 == 0) ? Text('Buy') : Text('Select'),
              onPressed: () {
                if (_button1 == 0) {
                  _buyPetPopup(25, 1);
                  // _saveButton1(1);
                }
                if (_button1 == 1) {
                  _youhaveselected('the scroom');
                  _saveSelectedPet(1);
                }
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
            Text('50',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: (_button2 == 0) ? Text('Buy') : Text('Select'),
              onPressed: () {
                if (_button2 == 0) {
                  _buyPetPopup(50, 2);

                  // _saveButton2(1);
                }
                if (_button2 == 1) {
                  _youhaveselected('the fat dog');
                  _saveSelectedPet(2);
                }
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
            Text('150',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 255, 255, 255),
                )),
            ElevatedButton(
              child: (_button3 == 0) ? Text('Buy') : Text('Select'),
              onPressed: () {
                if (_button3 == 0) {
                  _buyPetPopup(150, 3);
                  // _saveButton3(1);
                }
                if (_button3 == 1) {
                  _youhaveselected('Yoshi');
                  _saveSelectedPet(3);
                }
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
            offset: Offset(0, 135),
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
          Transform.translate(
            offset: Offset(0, 185),
            child: Container(
              alignment: Alignment.center,
              child: Text('This is your pet:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 255, 255, 255),
                  )),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 265),
            child: Container(
                alignment: Alignment.center,
                child: Image.asset(_getPetPath(_selectedpet))),
          ),
        ]),
      ),
    );
  }
}
