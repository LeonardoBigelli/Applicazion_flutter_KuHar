import 'dart:async';
import 'package:ku_har_app/interpreter.dart';

//class to listen the data stream and do inference on the data
class Consumer {
  late Stream<List<List<dynamic>>> _sensorDataStream;
  late StreamSubscription<List<List<dynamic>>> _streamHandling;
  late InterpreterTf interpreter;
  late int _inferenceResult;

  //costructor
  Consumer(this._sensorDataStream, String modelName) {
    interpreter = InterpreterTf(modelName);
    _streamHandling = _sensorDataStream.listen((window) {
      _doInference(window);
    });
  }

  //run inference
  void _doInference(List<List<dynamic>> window) {
    interpreter.runIference(window);
    _inferenceResult = interpreter.output;
  }

  //getter
  int get inferenceResult {
    return _inferenceResult;
  }

  void dispose() {
    _streamHandling.cancel();
  }
}
