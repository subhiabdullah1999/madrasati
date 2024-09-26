import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/ui/widgets/customRoundedButton.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ),
  );
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ),
  );

  Future<void> startAnimation() async {
    //cupertino page transtion duration
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              MediaQuery.of(context).size.height * (0.05),
        ),
        height: MediaQuery.of(context).size.height,
        // height: MediaQuery.of(context).size.height * (0.4),
        child: Lottie.asset(
          "assets/animations/onboarding4.json",
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height *
                  (0.400) *
                  _bottomMenuHeightUpAnimation.value -
              MediaQuery.of(context).size.height *
                  (0.05) *
                  _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width - 20,
            height: height,
            decoration: BoxDecoration(
              color: Color.fromARGB(221, 12, 12, 12),
              // color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * (0.1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    Utils.getTranslatedLabel(
                                        context, titelAuth),
                                    // context
                                    //     .read<AppConfigurationCubit>()
                                    //     .getAppConfiguration()
                                    //     .tagline,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Utils.getColorScheme(context).surface,
                                    ),
                                  ),
                                  Text(
                                    Utils.getTranslatedLabel(context, appName),
                                    // context
                                    //     .read<AppConfigurationCubit>()
                                    //     .getAppConfiguration()
                                    //     .tagline,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Utils.getColorScheme(context).primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.05),
                            ),
                            CustomRoundedButton(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  Routes.studentLogin,
                                );
                              },
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Utils.getColorScheme(context).primary,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(context, loginAsKey)} ${Utils.getTranslatedLabel(context, studentKey)}",
                              showBorder: false,
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.04),
                            ),
                            CustomRoundedButton(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.parentLogin);
                              },
                              widthPercentage: 0.8,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              buttonTitle:
                                  "${Utils.getTranslatedLabel(context, loginAsKey)} ${Utils.getTranslatedLabel(context, parentKey)}",
                              titleColor: Utils.getColorScheme(context).primary,
                              showBorder: true,
                              borderColor:
                                  Utils.getColorScheme(context).primary,
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          _buildLottieAnimation(),
          _buildBottomMenu(),
        ],
      ),
    );
  }
}
