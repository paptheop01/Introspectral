import 'main.dart';
import 'journal.dart';
import 'calendar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_service/audio_service.dart';

import 'dart:io';
import 'package:intl/intl.dart';

class HistoryLogWidget extends StatefulWidget {
  final DateTime? selectedDay;

  const HistoryLogWidget({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  _HistoryLogWidgetState createState() => _HistoryLogWidgetState();
}

class _HistoryLogWidgetState extends State<HistoryLogWidget> {
  late SQLservice sqLiteservice;
  List<Log> _logs = <Log>[];

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
      itemBuilder: (context, index) {
        if (DateFormat('yyyy-MM-dd').format(_logs[index].dateTime) ==
            DateFormat('yyyy-MM-dd')
                .format(widget.selectedDay ?? DateTime.now()))
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
                ],
              ));
        else
          return Text('');
      },
      itemCount: _logs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 202, 212, 211),
      appBar: AppBar(
        title: Text('View your log from ' + widget.selectedDay.toString()),
      ),
      body: Stack(children: <Widget>[
        Container(),
        _buildLogList(),
      ]),
    );
  }
}
