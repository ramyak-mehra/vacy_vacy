import 'package:flutter/material.dart';

List<Color> getColor(int i) {
  {
    switch (i % 5) {
      case 1:
        return [Colors.red[100], Colors.red[400]];
      case 2:
        return [Colors.blue[100], Colors.blue[400]];
      case 3:
        return [Colors.purple[100], Colors.purple[400]];
      case 4:
        return [Colors.teal[100], Colors.teal[400]];
      case 0:
        return [Colors.green[100], Colors.green[400]];
      default:
        return [Colors.red[100], Colors.red[400]];
    }
  }
}
