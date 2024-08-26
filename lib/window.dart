import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Window extends ChangeNotifier {
  List<List<double>> _windownData =
      List.generate(200, (_) => List.filled(6, 0));
  //stream per il controllo del giroscopio
  StreamSubscription<GyroscopeEvent>? samplingGyr;
  //strem per il controllo dell'accelerometro
  StreamSubscription<AccelerometerEvent>? samplingAcc;
  //stream per la scrittura dei risultati
  StreamController<List<List<double>>> _streamHandling =
      StreamController<List<List<double>>>();
  //current time
  int old_time_gyr = DateTime.now().millisecond;
  int old_time_acc = DateTime.now().millisecond;
  //contatori
  int countAcc = 0;
  int countGyr = 0;

  /*****************TIMER********************/
  AccelerometerEvent? latestAccelerometerEvent;
  GyroscopeEvent? latestGyroscopeEvent;
  Timer? timer;
  int currentIndex = 0;
  /************************************/

  //funzione alternativa che sfrutta i Timer
  void timerWindow() {
    samplingAcc = accelerometerEvents.listen((event) {
      latestAccelerometerEvent = event;
    });

    samplingGyr = gyroscopeEvents.listen((event) {
      latestGyroscopeEvent = event;
    });

    timer = Timer.periodic(Duration(milliseconds: 10), _collectSensorData);
  }

  List<List<double>> get windownData {
    return _windownData;
  }

  //getter
  Stream<List<List<double>>> get streamHandling => _streamHandling.stream;

  void _stopSamplingGyr() {
    samplingGyr?.cancel();
  }

  void _stopSamplingAcc() {
    samplingAcc?.cancel();
  }

  bool checkHzAcc(int current_time) {
    bool ris = true;
    if ((current_time - this.old_time_acc > 12) &&
        (current_time - this.old_time_acc < 8)) {
      //range <8 e > 12 (+-2), vengono accettate distanze di 9,10,11 ms
      ris = false;
    }
    this.old_time_acc = current_time;

    return ris;
  }

  bool checkHzGyr(int current_time) {
    bool ris = true;
    if ((current_time - this.old_time_gyr > 12) &&
        (current_time - this.old_time_gyr < 8)) {
      ris = false;
    }
    this.old_time_gyr = current_time;

    return ris;
  }

  void checkFinished() {
    if (countAcc == 200 && countGyr == 200) {
      countAcc = 0;
      countGyr = 0;
      //notifica al provider
      notifyListeners();
    }
  }

  void _collectSensorData(Timer timer) {
    if (currentIndex < 200) {
      if (latestAccelerometerEvent != null && latestGyroscopeEvent != null) {
        _windownData[currentIndex][0] = latestAccelerometerEvent!.x;
        _windownData[currentIndex][1] = latestAccelerometerEvent!.y;
        _windownData[currentIndex][2] = latestAccelerometerEvent!.z;
        _windownData[currentIndex][3] = latestGyroscopeEvent!.x;
        _windownData[currentIndex][4] = latestGyroscopeEvent!.y;
        _windownData[currentIndex][5] = latestGyroscopeEvent!.z;
        print("Acc e gyr n° ${currentIndex}");
        currentIndex++;
      }
    } else {
      timer.cancel();
      samplingAcc?.cancel();
      samplingGyr?.cancel();
      //add to the stream
      _streamHandling.add(List<List<double>>.from(
          _windownData.map((e) => List<double>.from(e))));
      print(_windownData);
      //clear the window data
      _windownData.clear();
      notifyListeners();
    }
  }
}
