import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class TitlePrivacyPolicyText extends StatelessWidget {
  final String TextTitle;
  const TitlePrivacyPolicyText({super.key, required this.TextTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        Utils.getTranslatedLabel(context, TextTitle),
        style: TextStyle(
          color: Utils.getColorScheme(context).secondary,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
