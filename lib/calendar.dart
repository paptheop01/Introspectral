// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:introspectral/habitadd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:introspectral/main.dart';
import 'package:introspectral/habit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:introspectral/utils.dart';

class CalendarScreenWidget extends StatefulWidget {
  const CalendarScreenWidget({Key? key}) : super(key: key);

  @override
  _CalendarScreenWidgetState createState() => _CalendarScreenWidgetState();
}

class _CalendarScreenWidgetState extends State<CalendarScreenWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(45),
              child: Text(
                'My Calendar',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 36,
                ),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 10,
            child: Container(
              width: 372,
              height: 380,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 216, 232, 218),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 120),
            child: TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
          Positioned(
            bottom: 120,
            left: 130,
            child: ElevatedButton(
              child: Text("See that day's log"),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
