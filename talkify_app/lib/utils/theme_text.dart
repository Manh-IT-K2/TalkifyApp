import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryFont {
  static String fontFamily = "Josefin Sans";

  // type text thin
  static TextStyle thin(double size) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w100,
      fontSize: size,
    );
  }

  // type text light
  static TextStyle light(double size) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w300,
      fontSize: size,
    );
  }

  // type text medium
  static TextStyle medium(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: size);
  }

  // type text bold
  static TextStyle bold(double size) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: size,
    );
  }

  // type title text thin
  static TextStyle titleThin() {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w100,
      fontSize: 6.w,
    );
  }

  // type title text light
  static TextStyle titleLight() {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w300,
      fontSize: 6.w,
    );
  }

  // type title text medium
  static TextStyle titleMedium() {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 6.w);
  }

  // type title text bold
  static TextStyle titleBold() {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 6.w,
    );
  }

  // type subtitle text thin
  static TextStyle subTitleThin() {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w100,
      fontSize: 4.w,
    );
  }

  // type subtitle text light
  static TextStyle subTitleLight() {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w300,
      fontSize: 4.w,
    );
  }

  // type subtitle text medium
  static TextStyle subTitleMedium() {
    return TextStyle(
        fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 4.w);
  }

  // type subtitle text bold
  static TextStyle subTitleBold() {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 4.w,
    );
  }
}
