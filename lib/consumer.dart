import 'dart:async';
import 'package:ku_har_app/interpreter.dart';

//class to listen the data stream and do inference on the data
class Consumer {
  //stream vero e proprio
  late Stream<List<List<dynamic>>> _sensorDataStream;
  //sottoscrizione allo stream
  late StreamSubscription<List<List<dynamic>>> _streamHandling;
  // stream per i risultati
  final StreamController<int> _streamResults =
      StreamController<int>.broadcast();
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
    _streamResults.add(_inferenceResult);
  }

  //getter
  int get inferenceResult {
    return _inferenceResult;
  }

  void dispose() {
    _streamHandling.cancel();
  }
}
