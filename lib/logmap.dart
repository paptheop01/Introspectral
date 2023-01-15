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
import 'stats.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLogWidget extends StatefulWidget {
  const MapLogWidget({Key? key}) : super(key: key);

  @override
  _MapLogWidgetState createState() => _MapLogWidgetState();
}

class _MapLogWidgetState extends State<MapLogWidget> {
  late SQLservice sqLiteservice;
  List<Log> _logs = <Log>[];
  List<LatLng> coordinates = [
    LatLng(37.4219999, -122.0840575),
    LatLng(37.4629101, -122.2449094),
    LatLng(37.3092293, -122.1136845),
    LatLng(37.2742199, -122.0328104)
  ];

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 202, 212, 211),
      appBar: AppBar(
        title: const Text('Map OverView'),
      ),
      body: Stack(children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        //_buildLogList(),
      ]),
    );
  }
}
