
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;


class HabitListScreenWidget extends StatefulWidget {
  const HabitListScreenWidget({Key?key}) : super(key:key);

  
  @override
  _HabitListScreenWidgetState createState() => _HabitListScreenWidgetState();
}

class _HabitListScreenWidgetState extends State<HabitListScreenWidget> {
  
  late SQLservice sqLiteservice;
  List<Task> _tasks=<Task>[];
  void _addNewTask() async{
     Task? newTask= await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewEditHabitWidget() ));
      if(newTask!=null){
        final newId=await sqLiteservice.addTask(newTask);
        newTask.id=newId;

        _tasks.add(newTask);
        setState(() {
          
        });

      }

  }
  @override
  void initState(){
    super.initState();
    sqLiteservice=SQLservice();
    sqLiteservice.initDB().whenComplete(() async{
      final tasks= await sqLiteservice.getTasks();
      setState(() {
        _tasks=tasks;
      });
    });
    
  }
  

  Widget _buildHabitList() {
    return ListView.separated(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index)  {
        IconData iconData;
        String toolTip;
        TextDecoration textDEc;

        iconData=_tasks[index].completed ?  Icons.check_box_outlined:  Icons.check_box_outline_blank_outlined;
        toolTip=_tasks[index].completed ?  'Mark as Incomplete':  'Mark as completed';
        textDEc=_tasks[index].completed ?  TextDecoration.lineThrough:  TextDecoration.none;
        return ListTile(
          

          leading: IconButton(
            icon:  Icon(iconData),
            onPressed: () {
              _tasks[index].completed = _tasks[index].completed? false:true ;
              sqLiteservice.updateComplete(_tasks[index]);
              setState(() {
                
              });
            },
            tooltip: toolTip,),
          title: Text(_tasks[index].title,
              style: TextStyle(decoration: textDEc),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: _tasks[index].alarm==null? false:true,
                child: Text(_tasks[index].alarm!=null ? _tasks[index].alarm!.format(context):'',
                style: TextStyle(decoration: textDEc),)
                ),
                IconButton(onPressed: () {_deleteTask(index);}, 
                icon: Icon(Icons.delete),
                tooltip: 'Delete Task',),
                
            ],
          ),
        
        );},
        
      separatorBuilder: (context, index) =>const Divider(),
      itemCount: _tasks.length,
    );
  }

  void _deleteTask(int idx) async{
    bool? delTask = await showDialog<bool>(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Delete Task?'),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context,false), 
          child: const Text('cancel')),
          TextButton(onPressed: () => Navigator.pop(context,true), 
          child: const Text('delete')),
        ],
      ));
    if(delTask!){
      final task=_tasks.elementAt(idx);
      try{
        sqLiteservice.deleteTask(task.id);
        _tasks.removeAt(idx);
      } catch (err) {
          debugPrint('Could not delete task $task : $err');
      }
      setState(() {
        
      });

    }  

  }
  double timeOfDaytoDouble(TimeOfDay myTime) => myTime.hour+myTime.minute /60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body : _buildHabitList(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(onPressed: () {}, icon: const Icon(null))
          ],
        ),
        color: Colors.blue,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewTask,
        backgroundColor: Colors.teal,
        tooltip: 'Add Task',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
  
}


class Task {
  int? id;
  String title;
  String? description;
  TimeOfDay? alarm;
  bool completed;
  Task({
    this.id,
    required this.title, 
    this.description, 
    this.alarm, 
    required this.completed }); 


  Map<String,dynamic> toMap(){
    final record={'title':title,'completed':completed?1:0};
    if(description!=null){
      record.addAll({'description':'$description'});
    }
    if(alarm!=null){
      record.addAll({'alarm':'${alarm!.hour}:${alarm!.minute}'});
    }
    return record;

  }
  Task.fromMap(Map<String,dynamic> task):
    id=task['id'],
    title=task['title'],
    description=task['description'],
    alarm=(task['alarm']!=null) ? TimeOfDay(hour: int.parse(task['alarm'].split(':')[0]), minute:int.parse(task['alarm'].split(':')[1]) ):null ,
    completed= task['completed']==1 ? true : false;



}



class SQLservice{
  Future <Database> initDB() async{
    return openDatabase(
      p.join(await getDatabasesPath(), 'habits.db'),
      onCreate:(db, version) {
        return db.execute(
          'CREATE TABLE habits(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, completed REAL)'
        );
      },
      version: 1, 
    );
  
  }
  Future <List<Task>> getTasks() async{
    final db=await initDB();
    final List<Map<String,Object?>> queryResult= await db.query('habits');
    return queryResult.map((e) => Task.fromMap(e)).toList();
  }
  Future<int> addTask(Task task) async{
    final db= await initDB();
    return db.insert('habits', task.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future <void> deleteTask(final id) async{
    final db= await initDB();
    await db.delete('habits',where: 'id=?',whereArgs: [id]);
  }


  Future <void> updateComplete(Task task) async{
    final db= await initDB();
    await db.update('tasks',{'completed':task.completed?1:0},where: 'id=?',whereArgs: [task.id],conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future <void> deleteCompleted() async{
    final db= await initDB();
    await db.delete('tasks',where: 'completed=1');
  }
  Future <void> deleteAllTasks() async{
    final db= await initDB();
    await db.delete('tasks');
  }

}