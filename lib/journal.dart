import 'package:flutter/material.dart';
import 'package:introspectral/journaladd.dart';
import 'main.dart';

import 'package:flutter/widgets.dart';

import 'home.dart';

class JournalScreenWidget extends StatefulWidget {
  const JournalScreenWidget({Key? key}) : super(key: key);

  @override
  _JournalScreenWidgetState createState() => _JournalScreenWidgetState();
}

class _JournalScreenWidgetState extends State<JournalScreenWidget> {
  // Show a list of all the logs of today and allow the user to add new ones
  late SQLservice sqLiteservice;
  List<Log> _logs = <Log>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(),
        _buildLogList(),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewLog,
        backgroundColor: Colors.teal,
        tooltip: 'Add Habit',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildLogList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(_logs[index].text),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteLog(index),
            ),
          ),
        );
      },
      itemCount: _logs.length,
    );
  }

  void _addNewLog() async {
    // Show a dialog to add a new log
    Log? newLog = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddLogWidget()));
    if (newLog != null) {
      final newId = await sqLiteservice.addLog(newLog);
      newLog.id = newId;

      _logs.add(newLog);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    sqLiteservice = SQLservice();
    sqLiteservice.initDB().whenComplete(() async {
      final logs = await sqLiteservice.getLogs();
      setState(() {
        _logs = logs;
      });
    });
  }

  _deleteLog(int index) async {
    // Delete a log

    bool del = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Log'),
            content: Text('Are you sure you want to delete this log?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });

    if (del) {
      try {
        final log = _logs.elementAt(index);
        sqLiteservice.deleteLog(log.id);
        _logs.removeAt(index);
      } catch (err) {
        debugPrint('Could not delete log: $err');
      }
      setState(() {});
    }
  }
}
