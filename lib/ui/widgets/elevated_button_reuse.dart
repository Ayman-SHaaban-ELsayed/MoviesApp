import 'package:flutter/material.dart';
import 'package:movies_app/utils/size_utils.dart';

class ElevatedButtonReuse extends StatelessWidget {
  final Widget childType;
  final VoidCallback onPressed;
  final Color? background;

  const ElevatedButtonReuse({
    super.key,
    required this.childType,
    required this.onPressed,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background ?? Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * .01),
        child: childType,
      ),
    );
  }
}
