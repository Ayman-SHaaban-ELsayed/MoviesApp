import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static Future<bool?> getFlutterToast({
    required String message,
    required Color backGroundColor,
    required Color textColor,
    required double fontSize,
    ToastGravity gravity = ToastGravity.CENTER,
    int timeAppear = 1,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: timeAppear,
      backgroundColor: backGroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
