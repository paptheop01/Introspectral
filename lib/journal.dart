import 'package:flutter/material.dart';
import 'package:introspectral/journaladd.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';

import 'dart:io';

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
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(45),
            child: const Text(
              'Today\'s Journal',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 36,
              ),
            ),
          ),
        ),
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

  Color _getCardColor(int emotionID) {
    switch (emotionID) {
      case 0:
        return Colors.red.withOpacity(0.37);
      case 1:
        return Colors.orange.withOpacity(0.37);
      case 2:
        return Colors.deepPurple.withOpacity(0.37);
      case 3:
        return Colors.blue.withOpacity(0.37);
      case 4:
        return Colors.green.withOpacity(0.37);
      case 5:
        return Colors.lightGreen.withOpacity(0.37);
      case 6:
        return Colors.yellow.withOpacity(0.37);
      case 7:
        return Colors.red.withOpacity(0.37);
      case 8:
        return Colors.lightBlue.withOpacity(0.37);
      default:
        return Colors.grey.withOpacity(0.37);
    }
  }

  String _getEmotionPath(int emotionID) {
    switch (emotionID) {
      case 0:
        return 'assets/images/angry.png';
      case 1:
        return 'assets/images/annoyed.png';
      case 2:
        return 'assets/images/ashamed.png';
      case 3:
        return 'assets/images/bored.png';
      case 4:
        return 'assets/images/confused.png';
      case 5:
        return 'assets/images/content.png';
      case 6:
        return 'assets/images/curious.png';
      case 7:
        return 'assets/images/unkempt.png';
      case 8:
        return 'assets/images/energetic.png';
      default:
        return 'assets/images/angry.png';
    }
  }

  Widget _buildLogList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      itemBuilder: (context, index) {
        if (DateFormat('yyyy-MM-dd').format(_logs[index].dateTime) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: _getCardColor(_logs[index].emotionID),
              child: Column(
                children: [
                  ListTile(
                    title: Text(_logs[index].text),
                    subtitle: Text(DateFormat('yyyy-MM-dd HH:mm')
                        .format(_logs[index].dateTime)
                        .toString()),
                    trailing: Image.asset(
                      _getEmotionPath(_logs[index].emotionID),
                      width: 42,
                      height: 42,
                    ),
                  ),
                  _logs[index].voiceRecording == null
                      ? Container()
                      : ElevatedButton(
                          onPressed: () async {
                            if (_logs[index].voiceRecording != null) {
                              await AudioPlayer().play(DeviceFileSource(
                                  _logs[index].voiceRecording!));
                            }
                          },
                          child: Text('Play Recording'),
                        ),
                  _logs[index].photo == null
                      ? Container()
                      : Hero(
                          tag: 'imageHero${_logs[index].id}',
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) {
                                    return Scaffold(
                                      body: Center(
                                        child: Image.file(
                                          File(_logs[index].photo!),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            child: SizedBox(
                                width: 170,
                                child: Image.file(
                                  File(_logs[index].photo!),
                                  fit: BoxFit.contain,
                                )),
                          ),
                        ),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteLog(index),
                      )),
                ],
              ));
        } else
          return Container();
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
