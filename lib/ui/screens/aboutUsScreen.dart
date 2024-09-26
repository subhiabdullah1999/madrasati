import 'package:eschool/cubits/appSettingsCubit.dart';
import 'package:eschool/data/repositories/systemInfoRepository.dart';
import 'package:eschool/ui/widgets/appSettingsBlocBuilder.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/ui/widgets/logoApp_aboutApp.dart';
import 'package:eschool/ui/widgets/text_aboutApp.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider<AppSettingsCubit>(
        create: (context) => AppSettingsCubit(SystemRepository()),
        child: const AboutUsScreen(),
      ),
    );
  }
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final String aboutUsType = "about_us";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<AppSettingsCubit>().fetchAppSettings(type: aboutUsType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // AppSettingsBlocBuilder(appSettingsType: aboutUsType),

            CustomAppBar(title: Utils.getTranslatedLabel(context, aboutUsKey)),
            LogoappAboutapp(),
            SizedBox(
              height: 10,
            ),
            TextAboutapp(
              textaboutApp: textAboutApp,
              fontSize: 18,
              color: Colors.black,
              height: 1.8,
              padding: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  TextAboutapp(
                    textaboutApp: applicationrights,
                    fontSize: 18,
                    color: Colors.black45,
                    height: 1.8,
                    padding: 10,
                    fontStyle: FontStyle.italic,
                  ),
                  TextAboutapp(
                    textaboutApp: companyName,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1.8,
                    padding: 2,
                    fontStyle: FontStyle.italic,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextAboutapp(
                  textaboutApp: appVersionKey,
                  fontSize: 16,
                  color: Colors.black45,
                  height: 1.8,
                  padding: 2,
                  fontStyle: FontStyle.italic,
                ),
                TextAboutapp(
                  textaboutApp: "  1.0.3  ",
                  fontSize: 16,
                  color: Colors.black45,
                  height: 1.8,
                  padding: 2,
                  fontStyle: FontStyle.italic,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            TextAboutapp(
              textaboutApp: Developedwith,
              fontSize: 20,
              color: Colors.black45,
              height: 1.8,
              padding: 2,
              fontStyle: FontStyle.italic,
            ),
            TextAboutapp(
              textaboutApp: Withgreatpride,
              fontSize: 20,
              color: Theme.of(context).colorScheme.primary,
              height: 1.8,
              padding: 2,
              fontStyle: FontStyle.italic,
            ),
          ],
        ),
      ),
    );
  }
}
