import 'package:eschool/ui/widgets/svgButton.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';

Container bannerForTermsAndConditions(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.28,
    width: double.infinity,
    decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(Utils.getImagePath("splashMadrasati.png")))),
    child: Container(
      color: Colors.black.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: SvgButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      svgIconUrl: Utils.getBackButtonPath(context),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 30),
                alignment: Alignment.center,
                child: Text(
                  Utils.getTranslatedLabel(context, privacyPolicyKey),
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}
