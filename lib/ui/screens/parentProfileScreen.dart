import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/ui/widgets/guardianDetailsContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: Utils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: Utils.appBarSmallerHeightPercentage,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.05),
                  ),
                  GuardianDetailsContainer(
                    guardian: context.read<AuthCubit>().getParentDetails(),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: Utils.getTranslatedLabel(context, profileKey),
            ),
          ),
        ],
      ),
    );
  }
}
