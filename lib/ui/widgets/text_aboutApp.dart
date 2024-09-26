import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextAboutapp extends StatelessWidget {
  final String textaboutApp;
  final double fontSize;
  final double height;
  Color? color;
  double? padding;
  FontStyle? fontStyle;

  TextAboutapp(
      {super.key,
      required this.textaboutApp,
      required this.fontSize,
      required this.height,
      this.color,
      this.fontStyle,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding!),
      child: Text(
        Utils.getTranslatedLabel(context, textaboutApp),
        textAlign: TextAlign.center,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: fontSize,
            fontStyle: fontStyle,
            height: height),
      ),
    );
  }
}
