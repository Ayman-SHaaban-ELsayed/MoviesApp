import 'package:flutter/material.dart';

class SizeUtils {
  static double getWidth({required BuildContext context}) =>
      MediaQuery.of(context).size.width;

  static double getHeight({required BuildContext context}) =>
      MediaQuery.of(context).size.height;
}
