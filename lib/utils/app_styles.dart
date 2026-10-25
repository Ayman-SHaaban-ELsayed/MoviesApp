import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/utils/app_colors.dart';

// (regular) => 400   -   (medium) => 500   -   (semi-bold) => 600   -   (bold) => 700

class AppStyles {
  //Whites
  static TextStyle regular14White = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle regular15White = GoogleFonts.roboto(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle regular16White = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle regular20White = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle medium36White = GoogleFonts.roboto(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  static TextStyle bold20White = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
  static TextStyle bold24White = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
  static TextStyle bold36White = GoogleFonts.roboto(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  //Blacks
  static TextStyle semibold20Black = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static TextStyle regular16Black = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static TextStyle regular20Black = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static TextStyle bold20Black = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
  static TextStyle bold16Black = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  //Yellows
  static TextStyle regular16Yellow = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.yellow,
  );
  static TextStyle bold14Yellow = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.yellow,
  );
  static TextStyle bold20Yellow = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.yellow,
  );
  static TextStyle semibold20Yellow = GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.yellow,
  );
  static TextStyle regular16grey = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );
}
