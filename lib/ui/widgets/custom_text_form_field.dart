import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';

typedef OnChanged = void Function(String)?;
typedef OnValidator = String? Function(String?)?;

class CustomTextFormField extends StatelessWidget {
  final Color? borderColor;
  final Color? curserColor;
  final String? hintText;
  final String? labelText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;
  final TextEditingController? controller;
  final OnChanged onChanged;
  final OnValidator validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxLine;
  final String? obscuringCharacter;
  final bool? fill;
  final Color? filledColor;

  const CustomTextFormField({
    super.key,
    this.borderColor,
    this.curserColor,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.style,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.maxLine,
    this.obscuringCharacter,
    this.fill,
    this.filledColor,
    this.suffixIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: style,
      controller: controller,
      cursorColor: curserColor ?? AppColors.primary,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? "*",
      maxLines: maxLine ?? 1,
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
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
