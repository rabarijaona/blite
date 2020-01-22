import 'dart:async';

import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'minutes_and_seconds_hand.dart';

final radiansPerTick = radians(360 / 60);

final radiansPerHour = radians(360 / 12);

void main() => runApp(ClockCustomizer((ClockModel model) => BliteClockApp(model)));

class BliteClockApp extends StatefulWidget {
  const BliteClockApp(this.model);

  final ClockModel model;

  @override
  _BliteClockAppState createState() => _BliteClockAppState();
}

class _BliteClockAppState extends State<BliteClockApp> {
  var _now = DateTime.now();

  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(BliteClockApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hms().format(DateTime.now());
    
    String hour = DateFormat('HH').format(_now);
    String minutes = DateFormat('mm').format(_now);
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'It\'s $time',
        value: time,
      ),
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black,
            child: Center(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 82,
                      child: Center(child: Text(hour, style:GoogleFonts.montserrat(textStyle: TextStyle(fontSize: 50, fontWeight: FontWeight.w600, color: Colors.white)))),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.0) ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration( shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.0)  ),
                    ),
                  ),
                  MinutesHand(
                    color: Colors.black,
                    size: 25,
                    angleRadiansOfMinutes: _now.minute * radiansPerTick,
                    angleRadiansOfSeconds : _now.second * radiansPerTick,
                    minutesText: minutes,
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


