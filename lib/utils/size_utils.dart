import 'package:flutter/material.dart';

class SizeUtils {
  static double getWidth({required BuildContext context}) =>
      MediaQuery.of(context).size.width;

  static double getHeight({required BuildContext context}) =>
      MediaQuery.of(context).size.height;
}
extension ScreenUtils on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}