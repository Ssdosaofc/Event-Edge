import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  const MyText({super.key, required this.text, required this.fontColor, required this.fontSize, required this.fontWeight,required this.decoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.readexPro(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration
      ),
    );
  }
}
