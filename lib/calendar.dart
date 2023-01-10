import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:introspectral/main.dart';
import 'package:introspectral/habit.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreenWidget extends StatefulWidget {
  const CalendarScreenWidget({Key? key}) : super(key: key);

  @override
  _CalendarScreenWidgetState createState() => _CalendarScreenWidgetState();
}

class _CalendarScreenWidgetState extends State<CalendarScreenWidget> {
  late SQLservice sqLiteservice;
  int density = 0;
  List<Habit> _habits = <Habit>[];
  @override
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

        return ListTile(
          dense: true,
          visualDensity: VisualDensity(horizontal: 1.0, vertical: -4.0),
          leading: IconButton(
            icon: Icon(iconData),
            onPressed: () {
              _habits[index].completed = _habits[index].completed + 1;
              sqLiteservice.updateComplete(_habits[index]);
              setState(() {});
            },
            tooltip: toolTip,
          ),
          title: Text(
            _habits[index].title,
            style: TextStyle(decoration: textDEc),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _habits.length,
    );
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
