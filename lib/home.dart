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
    return Container(
      child: Scaffold(
        body: Center(
          child: Text('This is the Pordula Screen'),
        ),
      ),
    );
  }
}
