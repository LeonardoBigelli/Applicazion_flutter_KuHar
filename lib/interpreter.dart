import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class InterpreterTf extends ChangeNotifier {
  String modelName;
  int _output = -1;

  //costructor
  InterpreterTf(this.modelName);

  void runIference(List<List<double>> inputData) async {
    //output tensor definition
    var outputData = List.filled(1 * 10, 0).reshape([1, 10]); //10 classes
    print('input: $inputData');
    print('output lenght: $outputData');
    final interpreter = await Interpreter.fromAsset('assets/${modelName}');

    //run inference
    interpreter.run(inputData, outputData);

    //closing of the interpreter
    interpreter.close();
    _output = argMax(outputData);
    print(_output);
    //notify provider
    notifyListeners();
  }

  //function to calcolate the argmax value of a list
  int argMax(List input) {
    int lastIndex = 0;
    var maxElement = input[0];
    for (int i = 1; i < input.length; i++) {
      if (input[i] > maxElement) {
        maxElement = input[i];
        lastIndex = i;
      }
    }
    return lastIndex;
  }

  //getter of inference result
  int get output {
    return _output;
  }
}
