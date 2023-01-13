import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'main.dart';

import 'package:flutter/widgets.dart';

import 'home.dart';

class HabitListScreenWidget extends StatefulWidget {
  const HabitListScreenWidget({Key? key}) : super(key: key);

  @override
  _HabitListScreenWidgetState createState() => _HabitListScreenWidgetState();
}

class _HabitListScreenWidgetState extends State<HabitListScreenWidget> {
  late SQLservice sqLiteservice;
  List<Habit> _habits = <Habit>[];
  double _sum = 0.0;

  void _addNewHabit() async {
    Habit? newHabit = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ViewEditHabitWidget()));
    if (newHabit != null) {
      final newId = await sqLiteservice.addHabit(newHabit);
      newHabit.id = newId;

      _habits.add(newHabit);
      final habits = await sqLiteservice.getHabits();
      final sumt = await sqLiteservice.sumhabits_total();
      final sumc = await sqLiteservice.sumhabits_completed();
      setState(() {
        _habits = habits;
        _sum = sumc * 100 / sumt;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sqLiteservice = SQLservice();
    sqLiteservice.initDB().whenComplete(() async {
      final habits = await sqLiteservice.getHabits();
      final sumt = await sqLiteservice.sumhabits_total();
      final sumc = await sqLiteservice.sumhabits_completed();
      setState(() {
        _habits = habits;
        _sum = sumc * 100 / sumt;
      });
    });
  }

  Widget _buildHabitList() {
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
                'Habits',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 36,
                ),
              ),
            ),
          ),
          Positioned(
            key: UniqueKey(),
            top: 30,
            right: 30,
            child: SizedBox(
              key: UniqueKey(),
              height: 75.0,
              width: 75.0,
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(119, 150, 216, 159),
                valueColor: AlwaysStoppedAnimation(Color(0xFF00FF19)),
                // value: (_habits[0].completed) * 1.0 / 8,
                value: _sum / 100,
                strokeWidth: 8.0,
              ),
            ),
          ),
          Positioned(
            key: UniqueKey(),
            top: 55,
            right: 48,
            child: Text(
              _sum != 100 && _sum > 10
                  ? _sum.toStringAsFixed(1)
                  : _sum != 100
                      ? _sum.toStringAsFixed(2)
                      : '100',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 22,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 140),
            child: ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Stack(children: [
                    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 156, 171, 191),
                          borderRadius: BorderRadius.circular(25),
                        )),
                    Container(
                        height: 50,
                        width: 400 *
                            (_habits[index].completed / _habits[index].goal),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 132, 255),
                          borderRadius: BorderRadius.circular(25),
                        )),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        height: 50,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              _habits[index].title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () async {
                                if (_habits[index].completed > 0) {
                                  _habits[index].completed =
                                      _habits[index].completed - 1;
                                  sqLiteservice.updateComplete(_habits[index]);
                                  final habits =
                                      await sqLiteservice.getHabits();
                                  final sumt =
                                      await sqLiteservice.sumhabits_total();
                                  final sumc =
                                      await sqLiteservice.sumhabits_completed();
                                  setState(() {
                                    _habits = habits;
                                    _sum = sumc * 100 / sumt;
                                  });
                                }
                              },
                              child: Icon(
                                Icons.remove,
                                color: Colors.black,
                                size: 20,
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  elevation: 0,
                                  padding: EdgeInsets.zero),
                            ),
                            Text(
                              _habits[index].completed.toString() +
                                  '/' +
                                  _habits[index].goal.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_habits[index].completed <
                                    _habits[index].goal) {
                                  _habits[index].completed =
                                      _habits[index].completed + 1;
                                  sqLiteservice.updateComplete(_habits[index]);
                                  final habits =
                                      await sqLiteservice.getHabits();
                                  final sumt =
                                      await sqLiteservice.sumhabits_total();
                                  final sumc =
                                      await sqLiteservice.sumhabits_completed();
                                  setState(() {
                                    _habits = habits;
                                    _sum = sumc * 100 / sumt;
                                  });
                                }
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 20,
                              ),
                              style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  elevation: 0,
                                  padding: EdgeInsets.zero),
                            ),
                          ],
                        )),
                  ]);
                } else {
                  return Stack(
                    children: [
                      Center(
                          child: Container(
                              height: 50,
                              width: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 45),
                              child: Row(children: [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.black,
                                ),
                                Text('Delete')
                              ]))),
                      Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.startToEnd,
                        dismissThresholds: {DismissDirection.startToEnd: 0.4},
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  backgroundColor: Color(0xFF83B7B5),
                                  title: const Text(
                                    "Are you sure you want to delete this habit?",
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Container(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .pop(false),
                                              child: PhysicalModel(
                                                  elevation: 8.0,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  color: Color(0xFF5B68C0),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Container(
                                                      width: 66,
                                                      height: 32,
                                                      child: const Center(
                                                          child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))))),
                                          Spacer(),
                                          InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .pop(true),
                                              child: PhysicalModel(
                                                  elevation: 8.0,
                                                  color: Color(0xFFD21313),
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Container(
                                                      width: 66,
                                                      height: 32,
                                                      child: Center(
                                                          child: Text("Yes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white))))))
                                        ],
                                      )),
                                );
                              });
                        },
                        onDismissed: (direction) {
                          // Remove the item from the list

                          _deleteHabit(index);
                        },
                        child: Stack(children: [
                          Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF9CBF9C),
                                borderRadius: BorderRadius.circular(25),
                              )),
                          Container(
                              height: 50,
                              width: 400 *
                                  (_habits[index].completed /
                                      _habits[index].goal),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 25.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    _habits[index].title,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_habits[index].completed > 0) {
                                        _habits[index].completed =
                                            _habits[index].completed - 1;
                                        sqLiteservice
                                            .updateComplete(_habits[index]);
                                        final habits =
                                            await sqLiteservice.getHabits();
                                        final sumt = await sqLiteservice
                                            .sumhabits_total();
                                        final sumc = await sqLiteservice
                                            .sumhabits_completed();
                                        setState(() {
                                          _habits = habits;
                                          _sum = sumc * 100 / sumt;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        elevation: 0,
                                        padding: EdgeInsets.zero),
                                  ),
                                  Text(
                                    _habits[index].completed.toString() +
                                        '/' +
                                        _habits[index].goal.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_habits[index].completed <
                                          _habits[index].goal) {
                                        _habits[index].completed =
                                            _habits[index].completed + 1;
                                        sqLiteservice
                                            .updateComplete(_habits[index]);
                                        final habits =
                                            await sqLiteservice.getHabits();
                                        final sumt = await sqLiteservice
                                            .sumhabits_total();
                                        final sumc = await sqLiteservice
                                            .sumhabits_completed();
                                        setState(() {
                                          _habits = habits;
                                          _sum = sumc * 100 / sumt;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        elevation: 0,
                                        padding: EdgeInsets.zero),
                                  ),
                                ],
                              )),
                        ]),
                      ),
                    ],
                  );
                }
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: _habits.length,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteHabit(int idx) async {
    bool? delHabit = true;
    if (delHabit) {
      final habit = _habits.elementAt(idx);
      try {
        sqLiteservice.deleteHabit(habit.id);

        _habits.removeAt(idx);
      } catch (err) {
        debugPrint('Could not delete habit $habit : $err');
      }
      final habits = await sqLiteservice.getHabits();
      final sumt = await sqLiteservice.sumhabits_total();
      final sumc = await sqLiteservice.sumhabits_completed();
      setState(() {
        _habits = habits;
        _sum = sumc * 100 / sumt;
      });
    }
  }

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
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
        Container(),
        _buildHabitList(),
      ]),
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
