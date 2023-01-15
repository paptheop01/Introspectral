import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'habit.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late SQLservice sqLiteservice;
  int density = 0;
  List<Habit> _habits = <Habit>[];
  List<Habit> _habits4 = <Habit>[];
  int _consecutiveDays = 0;
  DateTime _lastUsedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    sqLiteservice = SQLservice();
    sqLiteservice.initDB().whenComplete(() async {
      final habits = await sqLiteservice.getHabits();
      final habits4 = await sqLiteservice.getHabits4top();

      setState(() {
        _habits = habits;
        _habits4 = habits4;
      });
    });
    _loadCounter();
  }

  void _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastUsedDate =
          DateTime.parse(prefs.getString('last_used_date') ?? '2022-01-20');
      _consecutiveDays = prefs.getInt('consecutive_days') ?? 0;
    });
  }

  void _updateCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentDate = DateTime.now();
    if (_lastUsedDate != null &&
        currentDate.difference(_lastUsedDate).inDays == 1) {
      setState(() {
        _consecutiveDays += 1;
      });
    } else {
      setState(() {
        _consecutiveDays = 1;
      });
    }
    final lastUsedDate =
        await prefs.setString('last_used_date', currentDate.toIso8601String());
    final consecutiveDays =
        await prefs.setInt('consecutive_days', _consecutiveDays);
  }

  void _seeHabits() async {
    Habit? habit = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HabitListScreenWidget()));
    if (habit != null) {
      setState(() {});
    }
  }

  //double watercups =

  Widget _buildHabitList() {
    return ListView.separated(
      padding: const EdgeInsets.all(3.0),
      itemBuilder: (context, index) {
        IconData iconData;
        String toolTip;
        TextDecoration textDEc;

        iconData = Icons.check_box_outline_blank_outlined;
        toolTip = 'Mark as completed';
        textDEc = TextDecoration.none;

        return Container(
          //height: 35.0,
          width: 3.0,
          child: ListTile(
            dense: true,
            visualDensity: VisualDensity(horizontal: 1.0, vertical: -4.0),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30.0,
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 35.0,
              ),
            ),
            title: Text(
              _habits4[index].title,
              style: TextStyle(decoration: textDEc),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: _habits4.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
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
                'Welcome Back!',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 36,
                ),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 20,
            child: Container(
              width: 190,
              height: 280,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 215, 255, 241),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 80,
            child: Text(
              'Habit List',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 80, 89),
                fontSize: 18,
              ),
            ),
          ),
          Container(
            width: 400,
            height: 800,
            child: Transform.translate(
              offset: Offset(0, 175),
              child: _buildHabitList(),
            ),
          ),
          Positioned(
            key: UniqueKey(),
            top: 360,
            left: 60,
            child: ElevatedButton(
              child: Text("See all habits"),
              onPressed: () {
                MyInheritedWidget.of(context).changePage(1);
                //  _seeHabits();
                //   Navigator.of(context).push(PageRouteBuilder(
                //     pageBuilder: (context, animation, animation1) {
                //   return HabitListScreenWidget();
                //    }));
              },
            ),
          ),
          Positioned(
            top: 150,
            right: 20,
            child: Image.asset('assets/images/hydrat.png'),
          ),
          Positioned(
            top: 170,
            right: 20,
            child: SizedBox(
              height: 35.0,
              width: 35.0,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  // watercups = await loadwatercups();
                  if (_habits[0].completed < 8) {
                    _habits[0].completed += 1;
                    sqLiteservice.updateComplete(_habits[0]);
                    setState(() {});
                  }
                },
                backgroundColor: Colors.teal,
                tooltip: 'Addwater',
              ),
            ),
          ),
          Positioned(
            top: 170,
            right: 133,
            child: SizedBox(
              height: 35.0,
              width: 35.0,
              child: FloatingActionButton(
                child: Icon(Icons.remove),
                onPressed: () {
                  if (_habits[0].completed > 0) {
                    _habits[0].completed -= 1;
                    sqLiteservice.updateComplete(_habits[0]);
                    setState(() {});
                  }
                },
                backgroundColor: Colors.teal,
                tooltip: 'remwater',
              ),
            ),
          ),
          Positioned(
            top: 212,
            right: 55,
            child: SizedBox(
              height: 75.0,
              width: 75.0,
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(0, 158, 158, 158),
                valueColor: AlwaysStoppedAnimation(Color(0xFF00FF19)),
                value: _habits.isEmpty ? 0 : (_habits[0].completed) * 1.0 / 8,
                //value: 0,
                strokeWidth: 5.0,
              ),
            ),
          ),
          Positioned(
            top: 292,
            right: 85,
            child: Text(
              (_habits.isEmpty ? 0 : _habits[0].completed).toString() +
                  '/' +
                  (_habits.isEmpty ? 8 : _habits[0].goal).toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 13,
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 150,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                /*  Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 215, 255, 241),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(5, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ), */
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _updateCounter,
                      child: Text('Check-in'),
                    ),
                    Image.asset(
                      'assets/images/fire.png',
                      width: 60,
                      height: 60,
                    ),
                    Text('Streak: $_consecutiveDays',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 255, 255, 255),
                          // fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
