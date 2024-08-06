import 'package:flutter/material.dart';

class Contatore extends ChangeNotifier{
  int _valore = 0;


  void incrementa(){
    _valore ++;
    notifyListeners();
  }

  void reset(){
    _valore = 0;
    notifyListeners();
  }

  int get valore{
    return _valore;
  }


}