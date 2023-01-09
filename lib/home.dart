import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'main.dart';
import 'habit.dart';

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
