// ignore_for_file: prefer_const_constructors
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/painting/box_decoration.dart';
import 'package:introspectral/habit.dart';
import 'package:introspectral/home.dart';

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
