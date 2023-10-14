import 'package:flutter/material.dart';

class BalladefabrikkenProvider extends ChangeNotifier {

  int _points = 16;
  int _redemtionCount = 0;

  int get points => _points;
  int get redemtionCount => _redemtionCount;

  set points(int newValue) {
    _points = newValue;
    notifyListeners();
  }

  set redemtionCount(int newValue) {
    _redemtionCount = newValue;
    notifyListeners();
  }

}