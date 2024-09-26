import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class LogoappAboutapp extends StatelessWidget {
  const LogoappAboutapp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * (0.29),
      child: Image.asset(Utils.getImagePath("splashMadrasati.png")),
    );
  }
}
