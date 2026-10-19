import 'package:flutter/material.dart';

import '../../utils/size_utils.dart';

class ElevatedButtonReuse extends StatelessWidget {
  final Widget ChildType;
  final VoidCallback onpressed;
  final Color? background;

  const ElevatedButtonReuse({
    super.key,
    required this.ChildType,
    required this.onpressed,
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
      onPressed: onpressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * .01),
        child: ChildType,
      ),
    );
  }
}
