import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Window extends ChangeNotifier {
  List<List> _windownData = List.generate(200, (_) => List.filled(6, 0));
  //stream per il controllo del giroscopio
  StreamSubscription<GyroscopeEvent>? samplingGyr;
  //strem per il controllo dell'accelerometro
  StreamSubscription<AccelerometerEvent>? samplingAcc;

  /*****************TIMER********************/
  AccelerometerEvent? accelerometerEvent;
  GyroscopeEvent? gyroscopeEvent;
  Timer? timer;
  int i = 0;
  /************************************/

  //function to read sensors throw a Timer to repet
  void timerWindow(int ms) {
    samplingAcc = accelerometerEvents.listen((event) {
      accelerometerEvent = event;
    });

    samplingGyr = gyroscopeEvents.listen((event) {
      gyroscopeEvent = event;
    });

    timer = Timer.periodic(Duration(milliseconds: ms), _collectSensorData);
  }

  List<List> get windownData {
    return _windownData;
  }

  //function to create a window
  void _collectSensorData(Timer timer) {
    if (i < 200) {
      if (accelerometerEvent != null && gyroscopeEvent != null) {
        _windownData[i][0] = accelerometerEvent?.x;
        _windownData[i][1] = accelerometerEvent?.y;
        _windownData[i][2] = accelerometerEvent?.z;
        _windownData[i][3] = gyroscopeEvent?.x;
        _windownData[i][4] = gyroscopeEvent?.y;
        _windownData[i][5] = gyroscopeEvent?.z;
        print("Campionato acc e gyr n° ${i}");
        i++;
      }
    } else {
      timer.cancel();
      samplingAcc?.cancel();
      samplingGyr?.cancel();
      //provider notification
      notifyListeners();
    }
  }
}
