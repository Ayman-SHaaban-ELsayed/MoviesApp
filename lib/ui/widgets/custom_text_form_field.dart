import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';

typedef OnChanged = void Function(String)?;
typedef OnValidator = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  final Color? borderColor;
  final Color? cursercolor;
  final String? hinttext;
  final String? labeltext;
  final TextStyle? hintstyle;
  final TextStyle? labelstyle;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final TextStyle? style;
  final TextEditingController? controller;
  final OnChanged onChanged;
  final OnValidator validator;
  final TextInputType? keyboradtype;
  final bool? obscuretext;
  final int? maxline;
  final String? obscuringCharacter;
  final bool? fill;
  final Color? filledColor;

  const CustomTextFormField({
    super.key,
    this.borderColor,
    this.cursercolor,
    this.hinttext,
    this.hintstyle,
    this.labeltext,
    this.labelstyle,
    this.prefixIcon,
    this.sufixIcon,
    this.style,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboradtype,
    this.obscuretext,
    this.maxline,
    this.obscuringCharacter,
    this.fill,
    this.filledColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      controller: controller,
      cursorColor: cursercolor ?? AppColors.primary,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboradtype ?? TextInputType.text,
      obscureText: obscuretext ?? false,
      obscuringCharacter: obscuringCharacter ?? "*",
      maxLines: maxline ?? 1,
      decoration: InputDecoration(
        filled: fill,
        fillColor: filledColor,
        enabledBorder: _buildOutlineInputBorder(
          borderColor: borderColor ?? Colors.transparent,
        ),
        focusedBorder: _buildOutlineInputBorder(
          borderColor: borderColor ?? Colors.transparent,
        ),
        errorBorder: _buildOutlineInputBorder(borderColor: AppColors.red),
        focusedErrorBorder: _buildOutlineInputBorder(
          borderColor: AppColors.red,
        ),
        hintText: hinttext,
        hintStyle: hintstyle,
        labelText: labeltext,
        labelStyle: labelstyle,
        prefixIcon: prefixIcon,
        suffixIcon: sufixIcon,
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder({required Color borderColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(width: 2, color: borderColor),
    );
  }
}
