import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'habit.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key}) : super(key: key);

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  /*
  Future<void> persistwatercups(int watercups) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('watercups', watercups);
  }

  Future<int> loadwatercups() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('watercups') ?? 0;
  }
*/
  int watercups = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return Scaffold(
      body: Stack(
        children: <Widget>[
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
                  if (watercups < 8) {
                    watercups += 1;
                    // persistwatercups(watercups);
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
                  if (watercups > 0) {
                    watercups -= 1;
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
                value: watercups / 8,
                strokeWidth: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
