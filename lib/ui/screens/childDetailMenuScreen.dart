import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/data/models/subject.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';

import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/utils/animationConfiguration.dart';

import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/systemModules.dart';
import 'package:eschool/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChildDetailMenuScreen extends StatefulWidget {
  final Student student;
  final List<Subject> subjectsForFilter;
  const ChildDetailMenuScreen({
    Key? key,
    required this.student,
    required this.subjectsForFilter,
  }) : super(key: key);

  @override
  ChildDetailMenuScreenState createState() => ChildDetailMenuScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => ChildDetailMenuScreen(
        subjectsForFilter: arguments['subjectsForFilter'],
        student: arguments['student'],
      ),
    );
  }
}

class ChildDetailMenuScreenState extends State<ChildDetailMenuScreen> {
  List<MenuContainerDetails> _menuItems = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setMenuItems();
    });
    super.initState();
  }

  void setMenuItems() {
    //Menu will have module Id attache to it same as student home bottm sheet
    _menuItems = [
      MenuContainerDetails(
        moduleId: assignmentManagementModuleId.toString(),
        route: Routes.childAssignments,
        arguments: {
          "childId": widget.student.id,
          "subjects": widget.subjectsForFilter
        },
        iconPath: Utils.getImagePath("assignment_icon_parent.svg"),
        title: Utils.getTranslatedLabel(context, assignmentsKey),
      ),
      MenuContainerDetails(
        moduleId: defaultModuleId.toString(),
        route: Routes.childTeachers,
        arguments: widget.student.id,
        iconPath: Utils.getImagePath("teachers_icon.svg"),
        title: Utils.getTranslatedLabel(context, teachersKey),
      ),
      MenuContainerDetails(
        moduleId: attendanceManagementModuleId.toString(),
        route: Routes.childAttendance,
        arguments: widget.student.id,
        iconPath: Utils.getImagePath("attendance_icon.svg"),
        title: Utils.getTranslatedLabel(context, attendanceKey),
      ),
      MenuContainerDetails(
        moduleId: timetableManagementModuleId.toString(),
        route: Routes.childTimeTable,
        arguments: widget.student.id,
        iconPath: Utils.getImagePath("timetable_icon.svg"),
        title: Utils.getTranslatedLabel(context, timeTableKey),
      ),
      MenuContainerDetails(
        moduleId: holidayManagementModuleId.toString(),
        route: Routes.holidays,
        arguments: widget.student.id,
        iconPath: Utils.getImagePath("holiday_icon.svg"),
        title: Utils.getTranslatedLabel(context, holidaysKey),
      ),
      MenuContainerDetails(
        moduleId: examManagementModuleId.toString(),
        route: Routes.exam,
        arguments: {
          "childId": widget.student.id,
          "subjects": widget.subjectsForFilter
        },
        iconPath: Utils.getImagePath("exam_icon.svg"),
        title: Utils.getTranslatedLabel(context, examsKey),
      ),
      MenuContainerDetails(
        moduleId: examManagementModuleId.toString(),
        route: Routes.childResults,
        arguments: {
          "childId": widget.student.id,
          "subjects": widget.subjectsForFilter
        },
        iconPath: Utils.getImagePath("result_icon.svg"),
        title: Utils.getTranslatedLabel(context, resultKey),
      ),
      MenuContainerDetails(
        moduleId:
            "$assignmentManagementModuleId$moduleIdJoiner$examManagementModuleId",
        route: Routes.subjectWiseReport,
        arguments: {
          "childId": widget.student.id,
          "subjects": widget.subjectsForFilter
        },
        iconPath: Utils.getImagePath("reports_icon.svg"),
        title: Utils.getTranslatedLabel(context, reportsKey),
      ),
      MenuContainerDetails(
        moduleId: feesManagementModuleId.toString(),
        route: Routes.childFees,
        arguments: widget.student,
        iconPath: Utils.getImagePath("fees_icon.svg"),
        title: Utils.getTranslatedLabel(context, feesKey),
      ),
      MenuContainerDetails(
        moduleId: galleryManagementModuleId.toString(),
        route: Routes.schoolGallery,
        arguments: widget.student,
        iconPath: Utils.getImagePath("gallery.svg"),
        title: Utils.getTranslatedLabel(context, galleryKey),
      ),
    ];

    setState(() {});
  }

  Widget _buildAppBar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      heightPercentage: Utils.appBarSmallerHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          context.read<AuthCubit>().isParent()
              ? const CustomBackButton()
              : const SizedBox(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              Utils.getTranslatedLabel(context, menuKey),
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: Utils.screenTitleFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationAndMenu() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: 25,
        left: MediaQuery.of(context).size.width * (0.045),
        right: MediaQuery.of(context).size.width * (0.045),
        top: Utils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: Utils.appBarMediumtHeightPercentage,
            ) -
            55,
      ),
      child: Column(
        children: List.generate(_menuItems.length,
            (index) => _buildMenuContainer(itemIndex: index)),
      ),
    );
  }

  Widget _buildMenuContainer({
    required int itemIndex,
  }) {
    final menuItem = _menuItems[itemIndex];
    return Utils.isModuleEnabled(context: context, moduleId: menuItem.moduleId)
        ? Animate(
            effects: listItemAppearanceEffects(
                itemIndex: itemIndex, totalLoadedItems: _menuItems.length),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  print(_menuItems[itemIndex].arguments);
                  Navigator.of(context).pushNamed(_menuItems[itemIndex].route,
                      arguments: _menuItems[itemIndex].arguments);
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, boxConstraints) {
                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.225),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            width: boxConstraints.maxWidth * (0.200),
                            child: SvgPicture.asset(
                                _menuItems[itemIndex].iconPath),
                          ),
                          SizedBox(
                            width: boxConstraints.maxWidth * (0.025),
                          ),
                          SizedBox(
                            width: boxConstraints.maxWidth * (0.475),
                            child: Text(
                              _menuItems[itemIndex].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            radius: 17.5,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 22.5,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                          SizedBox(
                            width: boxConstraints.maxWidth * (0.035),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildInformationAndMenu(),
          _buildAppBar(context),
        ],
      ),
    );
  }
}

//class to maintain details required by each menu items
class MenuContainerDetails {
  String iconPath;
  String title;
  String route;
  String moduleId;
  Object? arguments;

  MenuContainerDetails({
    required this.iconPath,
    required this.title,
    required this.route,
    required this.moduleId,
    this.arguments,
  });
}
