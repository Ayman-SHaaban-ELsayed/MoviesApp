import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class WatchButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WatchButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffE82626),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: context.height * 0.015),
        ),
        onPressed: onPressed,
        child: Text('Watch', style: AppStyles.bold20White),
      ),
    );
  }
}
