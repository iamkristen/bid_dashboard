import 'package:flutter/material.dart';

class AppTextStyles {
  static const String poppins = "Poppins";
  static const String iceberg = "Iceberg";

  static const FontWeight poppinsThin = FontWeight.w100;
  static const FontWeight poppinsRegular = FontWeight.w400;
  static const FontWeight poppinsBold = FontWeight.w700;

  static const TextStyle poppinsThinStyle = TextStyle(
    fontFamily: poppins,
    fontWeight: poppinsThin,
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle poppinsRegularStyle = TextStyle(
    fontFamily: poppins,
    fontWeight: poppinsRegular,
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle poppinsBoldStyle = TextStyle(
    fontFamily: poppins,
    fontWeight: poppinsBold,
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle poppinsItalicStyle = TextStyle(
    fontFamily: poppins,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontSize: 16,
  );

  static const TextStyle icebergStyle = TextStyle(
    fontFamily: iceberg,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    fontSize: 16,
  );
}
