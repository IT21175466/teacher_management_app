import 'package:attendence_manager/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    required this.fontsize,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.textBlackColor,
    this.textalign = TextAlign.center,
    this.decoration = TextDecoration.none,
    super.key,
  });

  final String text;
  final double fontsize;
  final FontWeight? fontWeight;
  final Color color;
  final TextAlign textalign;
  final TextDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontsize,
        fontWeight: fontWeight,
        fontFamily: 'Poppins',
        decoration: decoration,
      ),
      textAlign: textalign,
    );
  }
}
