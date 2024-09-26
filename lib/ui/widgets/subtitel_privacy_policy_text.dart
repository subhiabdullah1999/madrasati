import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class SubtitelPrivacyPolicyText extends StatelessWidget {
  final String subTitel;
  const SubtitelPrivacyPolicyText({super.key, required this.subTitel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        Utils.getTranslatedLabel(context, subTitel),
        style: TextStyle(
            color: Utils.getColorScheme(context).secondary,
            fontWeight: FontWeight.w400,
            fontSize: 16.0,
            height: 1.8),
        textAlign: TextAlign.start,
      ),
    );
  }
}
