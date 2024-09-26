import 'package:eschool/cubits/appSettingsCubit.dart';
import 'package:eschool/data/repositories/systemInfoRepository.dart';
import 'package:eschool/ui/widgets/appSettingsBlocBuilder.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/ui/widgets/bannerForTermsAndConditions.dart';
import 'package:eschool/ui/widgets/subtitel_privacy_policy_text.dart';
import 'package:eschool/ui/widgets/title_privacy_policy_text.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<AppSettingsCubit>(
        create: (context) => AppSettingsCubit(SystemRepository()),
        child: const PrivacyPolicyScreen(),
      ),
    );
  }
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  // final String privacyPolicyType = "privacy_policy";

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero, () {
  //     context
  //         .read<AppSettingsCubit>()
  //         .fetchAppSettings(type: privacyPolicyType);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bannerForTermsAndConditions(context),

            SizedBox(
              height: 20,
            ),
            TitlePrivacyPolicyText(
              TextTitle: privacyPolicyKey,
            ),
            SubtitelPrivacyPolicyText(
              subTitel: introApp,
            ),
            TitlePrivacyPolicyText(
              TextTitle: Introductionapplication,
            ),

            // AppSettingsBlocBuilder(
            //   appSettingsType: privacyPolicyType,
            // ),
            // CustomAppBar(
            //   title: Utils.getTranslatedLabel(context, privacyPolicyKey),
            // )
          ],
        ),
      ),
    );
  }
}
