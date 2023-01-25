// ignore_for_file: prefer_const_constructors
import 'package:introspectral/journal.dart';
import 'package:introspectral/stats.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:workmanager/workmanager.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/box_decoration.dart';
import 'package:introspectral/habit.dart';
import 'package:introspectral/home.dart';
import 'package:introspectral/journal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:introspectral/calendar.dart';
import 'package:introspectral/journalhistory.dart';

@pragma('vm:entry-point')
void updatereset() {
  DateTime time = DateTime.now();
  late SQLservice sqLiteservice;
  sqLiteservice = SQLservice();
  sqLiteservice.updatereset();
  _updatealarm();
  print('$time Tried to update');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(const MyApp());
  final int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(minutes: 1), helloAlarmID, updatereset,
      startAt: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 23, 59, 59),
      rescheduleOnReboot: true,
      allowWhileIdle: true,
      wakeup: true);
}

void _loadalarm() async {
  SharedPreferences prefsalarm = await SharedPreferences.getInstance();
  var CurrentDate = DateTime.now();
  var last_alarm_date =
      DateTime.parse(prefsalarm.getString('last_alarm_date') ?? '2022-01-01');
  Future<void> deleteDb() async {
    deleteDatabase(p.join(await getDatabasesPath(), 'habits.db'));
  }

  if (last_alarm_date == DateTime.parse('2022-01-01') ||
      CurrentDate.day != last_alarm_date.day ||
      CurrentDate.month != last_alarm_date.month ||
      CurrentDate.year != last_alarm_date.year) {
    print('Update from init');
    updatereset();
  }
}

void _updatealarm() async {
  SharedPreferences prefsalarm = await SharedPreferences.getInstance();

  DateTime currentDate = DateTime.now();
  Timer timer;
  timer = new Timer(const Duration(seconds: 2), () {
    var lastUsedDate =
        prefsalarm.setString('last_alarm_date', currentDate.toIso8601String());
  });
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

class MyInheritedWidget extends InheritedWidget {
  final int _currentPage;
  final Function(int) changePage;

  MyInheritedWidget({
    Key? key,
    required Widget child,
    required this.changePage,
    required int currentPage,
  })  : _currentPage = currentPage,
        super(key: key, child: child);

  static MyInheritedWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  static MyInheritedWidget of(BuildContext context) {
    final MyInheritedWidget? result = maybeOf(context);
    assert(result != null, 'No Inherited Widget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(MyInheritedWidget old) {
    return _currentPage != old._currentPage;
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
      JournalScreenWidget(),
      CalendarScreenWidget(),
      StatsScreenWidget(),
    ];
    _loadalarm();
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
        changePage: _onItemTapped,
        currentPage: _selectedIndex,
        child: Container(
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
            )));
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
  String? city;
  String? photo;
  String? voiceRecording;

  Log(
      {this.id,
      required this.text,
      required this.emotionID,
      required this.dateTime,
      this.latitude,
      this.longitude,
      this.photo,
      this.city,
      this.voiceRecording});

  Map<String, dynamic> toMap() {
    final record = {
      'text': text,
      'emotionID': emotionID,
      'dateTime': dateTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'city': city,
      'photo': photo,
      'voiceRecording': voiceRecording
    };

    return record;
  }

  Log.fromMap(Map<String, dynamic> log)
      : id = log['id'],
        text = log['text'],
        emotionID = log['emotionID'],
        dateTime = DateTime.parse(log['dateTime']),
        latitude = log['latitude'],
        longitude = log['longitude'],
        city = log['city'],
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
            'CREATE TABLE logs(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, emotionID INTEGER, dateTime TEXT, latitude REAL, longitude REAL, photo TEXT, voiceRecording TEXT, city TEXT);');

        db.rawInsert('''INSERT INTO habits (id, title, completed, goal)
                        VALUES (0, 'water', 0, 8)''');
        return db;
      },
      version: 1,
    );
  }

  // TODO: Create CRUD methods for logs

  Future<List<Log>> getLogs() async {
    final db = await initDB();
    final List<Map<String, Object?>> queryResult = await db.query('logs');
    return queryResult.map((e) => Log.fromMap(e)).toList();
  }

  Future<int> addLog(Log log) async {
    final db = await initDB();
    return db.insert('logs', log.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteLog(final id) async {
    final db = await initDB();
    await db.delete('logs', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Map<dynamic, dynamic>>> lifeMood() async {
    final db = await initDB();
    final queryResult = await db
        .rawQuery(
            'SELECT emotionID, COUNT(*) as count FROM logs GROUP BY emotionID ORDER BY count DESC LIMIT 3')
        .then((data) => data.map((e) => Map.from(e)).toList());
    return queryResult;
  }

  Future<int> weekMood() async {
    final db = await initDB();
    String query = '''
    SELECT emotionID, COUNT(emotionID) as frequency 
    FROM logs
    WHERE dateTime >= ?
    GROUP BY emotionID
    HAVING COUNT(emotionID) = (SELECT MAX(frequency) FROM (SELECT emotionID, COUNT(emotionID) as frequency
                                 FROM logs
                                 WHERE dateTime >= ?
                                 GROUP BY emotionID))
  ''';
    final now = DateTime.now();
    final dateString = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(now.subtract(Duration(days: 7)));
    final queryResult = await db.rawQuery(query, [dateString, dateString]).then(
        (data) => data.map((e) => Map.from(e)).toList());
    if (queryResult.isEmpty)
      return -1;
    else
      return queryResult[0]['emotionID'];
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

  Future<void> updatereset() async {
    final db = await initDB();
    await db.update('habits', {'completed': 0},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Habit>> getHabits4top() async {
    final db = await initDB();
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery("SELECT * FROM habits LIMIT 4 OFFSET 1");
    return queryResult.map((e) => Habit.fromMap(e)).toList();
  }

  Future<int> sumhabits_total() async {
    final db = await initDB();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT SUM(goal) as total FROM habits');
    return result[0]['total'];
  }

  Future<int> sumhabits_completed() async {
    final db = await initDB();
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT SUM(completed) as total FROM habits');
    return result[0]['total'];
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





















/*

class UpdateHabitsWorker extends SimpleWorker {
  bool _firstRunAfterConstraintsNotMet = false;

  @override
  Future<void> doWork() async {
    // check if it's running after failed attempt
    if(_firstRunAfterConstraintsNotMet)
    {
      // Open the database
      var database = await openDatabase('habits.db');
      // Update the "completed" column of all habits
      await database.rawUpdate("UPDATE habits SET completed = 0");
      // Close the database
      await database.close();
      _firstRunAfterConstraintsNotMet = false;
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  @override
  void onConstraintsNotMet() {
    _firstRunAfterConstraintsNotMet = true;
    //cancel all the tasks
    Workmanager().cancelAll();
    //Immediately re-schedule the task
    Workmanager().enqueue(taskName, constraints: Constraints(networkType: NetworkType.connected));
    
    //create an Intent to launch the UpdateHabitsWorker
    var androidIntent = new AndroidIntent(
      actions: 'com.example.updatehabits',
      component: new AndroidComponent(
        component: 'com.example.updatehabits/com.example.updatehabits.UpdateHabitsWorker',
      ),
    );
    var pendingIntent = PendingIntent.fromAndroidIntent(androidIntent);
    //create an AlarmManager to schedule the task
        var alarmManager = AndroidAlarmManager.create();
    alarmManager.set(AndroidAlarmType.RTC_WAKEUP, DateTime.now().millisecondsSinceEpoch, pendingIntent);
  }

  void scheduleHabitsUpdate() {
    // Configure Workmanager to run our Worker at midnight every day
    var constraints = new Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true);

    Workmanager.initialize(
        callbackDispatcher,
        isInDebugMode: true,
        constraints: constraints);
    Workmanager().registerPeriodicTask(
        "1",
        "updateHabits",
        frequency: Duration(days: 1),
        initialDelay: Duration(seconds: 5),
        constraints: constraints);
  }
}
*/
