// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/box_decoration.dart';
import 'package:introspectral/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

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
        canvasColor: Color.fromARGB(255, 69, 139, 127),
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  void _gotohabits() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HabitListScreenWidget()));
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HabitListScreenWidget()));
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/back.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Center(
            child: new Text("Hello background"),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        fixedColor: Color.fromARGB(136, 0, 0, 0),
        items: [
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
        currentIndex: 0,
        onTap: _onItemTapped,
      ),
    );
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

class SQLservice {
  Future<Database> initDB() async {
    return openDatabase(
      p.join(await getDatabasesPath(), 'habits.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, completed INTEGER,goal INTEGER)');
      },
      version: 1,
    );
  }

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

