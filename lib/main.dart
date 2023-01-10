// ignore_for_file: prefer_const_constructors
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/box_decoration.dart';
import 'package:introspectral/habit.dart';
import 'package:introspectral/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:introspectral/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Introspectral',
      theme: ThemeData(
        canvasColor: Color.fromARGB(255, 69, 139, 127).withOpacity(0.3),
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: "Introspectral"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _pageController = PageController();
  List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomeScreenWidget(),
      HabitListScreenWidget(),
      CalendarScreenWidget(),
    ];
  }

  @override
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
          body: PageView(
            controller: _pageController,
            children: _pages,
            onPageChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green, // SELECTED TAB COLOR
            unselectedItemColor: const Color(0xCFFFFFFF),
            backgroundColor: Colors.grey, // BACKGROUND COLOR
            iconSize: 30,
            selectedFontSize: 15,
            unselectedFontSize: 15,
            elevation: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note),
                label: 'Log',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: 'Stats',
              ),
            ],
          ),
        ));
  }
}

class Habit {
  int? id;
  String title;
  int completed;
  int goal;
  Habit(
      {this.id,
      required this.title,
      required this.goal,
      required this.completed});

  Map<String, dynamic> toMap() {
    final record = {'title': title, 'completed': completed, 'goal': goal};

    return record;
  }

  Habit.fromMap(Map<String, dynamic> habit)
      : id = habit['id'],
        title = habit['title'],
        completed = habit['completed'],
        goal = habit['goal'];
}

class Log {
  int? id;
  String text;
  int emotionID;
  DateTime dateTime;
  double? latitude;
  double? longitude;
  File? photo;
  Uint8List? voiceRecording;

  Log(
      {this.id,
      required this.text,
      required this.emotionID,
      required this.dateTime,
      this.latitude,
      this.longitude,
      this.photo,
      this.voiceRecording});

  Map<String, dynamic> toMap() {
    final record = {
      'text': text,
      'emotionID': emotionID,
      'dateTime': dateTime,
      'latitude': latitude,
      'longitude': longitude,
      'photo': photo,
      'voiceRecording': voiceRecording
    };

    return record;
  }

  Log.fromMap(Map<String, dynamic> log)
      : id = log['id'],
        text = log['text'],
        emotionID = log['emotionID'],
        dateTime = log['dateTime'],
        latitude = log['latitude'],
        longitude = log['longitude'],
        photo = log['photo'],
        voiceRecording = log['voiceRecording'];
}

class SQLservice {
  Future<Database> initDB() async {
    return openDatabase(
      p.join(await getDatabasesPath(), 'habits.db'),
      onCreate: (db, version) {
        // Create tables for habits and logs
        db.execute(
            'CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, completed INTEGER,goal INTEGER);');
        db.execute(
            'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, emotionID INTEGER, dateTime TEXT, latitude REAL, longitude REAL, photo BLOB, voiceRecording BLOB);');
        return db;
      },
      version: 1,
    );
  }

  // TODO: Create CRUD methods for logs

  Future<List<Habit>> getHabits() async {
    final db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('habits');
    return queryResult.map((e) => Habit.fromMap(e)).toList();
  }

  Future<int> addHabit(Habit habit) async {
    final db = await initDB();
    return db.insert('habits', habit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteHabit(final id) async {
    final db = await initDB();
    await db.delete('habits', where: 'id=?', whereArgs: [id]);
  }

  Future<void> updateComplete(Habit habit) async {
    final db = await initDB();
    await db.update('habits', {'completed': habit.completed},
        where: 'id=?',
        whereArgs: [habit.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteCompleted() async {
    final db = await initDB();
    await db.delete('habits', where: 'completed=1');
  }

  Future<void> deleteAllHabits() async {
    final db = await initDB();
    await db.delete('habits');
  }
}
