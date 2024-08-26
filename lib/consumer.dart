import 'dart:async';
import 'package:ku_har_app/interpreter.dart';

//class to listen the data stream and do inference on the data
class Consumer {
  //stream vero e proprio
  late Stream<List<List<double>>> _sensorDataStream;
  //sottoscrizione allo stream
  late StreamSubscription<List<List<double>>> _streamHandling; //dato struttura
  // stream per i risultati
  final StreamController<int> _streamResults =
      StreamController<int>.broadcast();
  late InterpreterTf interpreter;
  late int _inferenceResult;
  //per la grafica
  Function(List<List<double>>, String) _onData;

  //constructor
  Consumer(this._sensorDataStream, String modelName, this._onData) {
    interpreter = InterpreterTf(modelName);
    _streamHandling = _sensorDataStream.listen((window) {
      print("dato letto: $window");
      _doInference(window);
    });
  }

  //run inference
  void _doInference(List<List<double>> window) {
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
