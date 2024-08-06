//V.1 CON PROVIDER
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ku_har_app/consumer.dart';
import 'package:ku_har_app/interpreter.dart';
import 'package:ku_har_app/window.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SensorScreen(),
    );
  }
}

class SensorScreen extends StatefulWidget {
  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  late Window _sensorManager;
  late Consumer _dataConsumer;
  String _dataOutput = 'Press the button to start collecting data';

  @override
  void initState() {
    super.initState();
    _sensorManager = Window();
  }

  void _startCollectingData() {
    setState(() {
      _dataOutput = 'Collecting data...';
    });

    _dataConsumer =
        Consumer(_sensorManager.streamHandling, "model_act_10_classes.tflite");

    _sensorManager.timerWindow();
  }

  @override
  void dispose() {
    _sensorManager.dispose();
    _dataConsumer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_dataOutput, textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startCollectingData,
              child: Text('Start Collecting Data'),
            ),
          ],
        ),
      ),
    );
  }
}
