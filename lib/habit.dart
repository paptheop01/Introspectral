import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'main.dart';
import 'home.dart';

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
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
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
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreenWidget()));
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
