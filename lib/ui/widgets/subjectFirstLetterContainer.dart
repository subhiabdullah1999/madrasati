import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';

class SubjectCodeContainer extends StatelessWidget {
  final String subjectCode;
  const SubjectCodeContainer({Key? key, required this.subjectCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        subjectCode,
        style: TextStyle(
          fontSize: Utils.subjectFirstLetterFontSize,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
