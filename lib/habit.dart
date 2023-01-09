import 'dart:async';

import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class HabitListScreenWidget extends StatefulWidget {
  const HabitListScreenWidget({Key? key}) : super(key: key);

  @override
  _HabitListScreenWidgetState createState() => _HabitListScreenWidgetState();
}

class _HabitListScreenWidgetState extends State<HabitListScreenWidget> {
  late SQLservice sqLiteservice;
  List<Habit> _habits = <Habit>[];
  void _addNewHabit() async {
    Habit? newHabit = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewEditHabitWidget()));
    if (newHabit != null) {
      final newId = await sqLiteservice.addHabit(newHabit);
      newHabit.id = newId;

      _habits.add(newHabit);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    sqLiteservice = SQLservice();
    sqLiteservice.initDB().whenComplete(() async {
      final habits = await sqLiteservice.getHabits();
      setState(() {
        _habits = habits;
      });
    });
  }

  Widget _buildHabitList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        IconData iconData;
        String toolTip;
        TextDecoration textDEc;

        iconData = Icons.check_box_outline_blank_outlined;
        toolTip = 'Mark as completed';
        textDEc = TextDecoration.none;

        return Stack(children: [
          /*Center(child:Container(
              height: 50,
                decoration: BoxDecoration(

                  borderRadius:BorderRadius.circular(25) ,
                  color: Colors.red,
                ),
              )),*/
          Dismissible(
            background: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.blue,
              ),
            ),
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              // Remove the item from the list

              _deleteHabit(index);
            },
            child: Stack(children: [
              Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0x3300FF19),
                    borderRadius: BorderRadius.circular(25),
                  )),
              Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF00FF19),
                    borderRadius: BorderRadius.circular(25),
                  )),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  height: 50,
                  padding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15.0),
                  child: Text(
                    _habits[index].title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )),
            ]),
          )
        ]);
      },

      /*return ListTile(
          

          leading: IconButton(
            icon:  Icon(iconData),
            onPressed: () {
              _habits[index].completed = _habits[index].completed +1 ;
              sqLiteservice.updateComplete(_habits[index]);
              setState(() {
                
              });
            },
            tooltip: toolTip,),
          title: Text(_habits[index].title,
              style: TextStyle(decoration: textDEc),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                IconButton(onPressed: () {_deleteHabit(index);}, 
                icon: Icon(Icons.delete),
                tooltip: 'Delete Habit',),
                
            ],
          ),
        
        );},
        */
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _habits.length,
    );
  }

  void _deleteHabit(int idx) async {
    bool? delHabit =
        true; /* await showDialog<bool>(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Delete Habit?'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context,false), 
          child: const Text('cancel')),
          TextButton(onPressed: () => Navigator.pop(context,true), 
          child: const Text('delete')),
        ],
      ));*/
    if (delHabit) {
      final habit = _habits.elementAt(idx);
      try {
        sqLiteservice.deleteHabit(habit.id);

        _habits.removeAt(idx);
      } catch (err) {
        debugPrint('Could not delete habit $habit : $err');
      }
      setState(() {});
    }
  }

  int _selectedIndex = 1;
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
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/back.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _buildHabitList(),
      ]),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewHabit,
        backgroundColor: Colors.teal,
        tooltip: 'Add Habit',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
