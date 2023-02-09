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
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLogWidget extends StatefulWidget {
  const MapLogWidget({Key? key}) : super(key: key);

  @override
  _MapLogWidgetState createState() => _MapLogWidgetState();
}

class _MapLogWidgetState extends State<MapLogWidget> {
  late SQLservice sqLiteservice;
  List<Log> _logs = <Log>[];

  late LatLngBounds latlngBounds;

  Set<Marker> _markers = <Marker>{};

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      latlngBounds = LatLngBounds(
          southwest: LatLng(37.93, 23.56), northeast: LatLng(38.10, 24.04));
      mapController = controller;
      var i = 0;
      for (var log in _logs) {
        if (log.latitude != null && log.longitude != null) {
          if (i == 0) {
            i++;
            latlngBounds = LatLngBounds(
                southwest: LatLng(log.latitude! - 0.1, log.longitude! - 0.1),
                northeast: LatLng(log.latitude! + 0.1, log.longitude! + 0.1));
          } else {
            latlngBounds = LatLngBounds(
                southwest: LatLng(
                    // Update the bounds to include the new marker
                    min(latlngBounds.southwest.latitude, log.latitude!),
                    min(latlngBounds.southwest.longitude, log.longitude!)),
                northeast: LatLng(
                    max(latlngBounds.northeast.latitude, log.latitude!),
                    max(latlngBounds.northeast.longitude, log.longitude!)));
          }
          _markers.add(Marker(
            markerId: MarkerId(log.id.toString()),
            position: LatLng(log.latitude!, log.longitude!),
            infoWindow: InfoWindow(
              title: log.text,
              snippet: log.dateTime.toString(),
            ),
          ));
        }
      }
    });
    Future.delayed(Duration(seconds: 2), () {
      // This is needed to wait for the map to be rendered
      controller.animateCamera(CameraUpdate.newLatLngBounds(latlngBounds, 50));
    });
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
    return Container(
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
        //backgroundColor: Color.fromARGB(255, 202, 212, 211),
        appBar: AppBar(
          title: const Text('Map OverView'),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(_markers),
        ),
      ),
    );
  }
}
