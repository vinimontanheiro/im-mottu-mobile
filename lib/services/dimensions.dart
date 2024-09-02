import 'package:flutter/material.dart';

abstract class Dimensions {
  static double widthOf(BuildContext? context, double percentValue) =>
      MediaQuery.of(context!).size.width * (percentValue / 100);

  static double heightOf(BuildContext? context, double percentValue) =>
      MediaQuery.of(context!).size.width * (percentValue / 100);

  static double top(BuildContext? context) =>
      MediaQuery.of(context!).padding.top > 0
          ? MediaQuery.of(context).padding.top
          : 50;
}
