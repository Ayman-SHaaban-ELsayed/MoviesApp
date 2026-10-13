import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

// (regular) => 400   -   (medium) => 500   -   (semi-bold) => 600   -   (bold) => 700

class AppStyles {
  //Whites
  static TextStyle regular14White = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle regular15White = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle regular16White = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle regular20White = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );
  static TextStyle medium36White = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );
  static TextStyle bold20White = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
  static TextStyle bold24White = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );
  static TextStyle bold36White = GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  //Blacks
  static TextStyle semibold20Black = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  static TextStyle regular16Black = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static TextStyle regular20Black = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static TextStyle bold20Black = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  //Yellows
  static TextStyle regular16Yellow = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.yellow,
  );
  static TextStyle bold14Yellow = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.yellow,
  );
  static TextStyle bold20Yellow = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.yellow,
  );
  static TextStyle semibold20Yellow = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.yellow,
  );
}
