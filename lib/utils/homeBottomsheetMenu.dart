import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/systemModules.dart';
import 'package:eschool/utils/utils.dart';

class Menu {
  final String title;
  final String iconUrl;
  final String menuModuleId; //This is fixed

  Menu(
      {required this.iconUrl, required this.title, required this.menuModuleId});
}

//To add all more menu here

final List<Menu> homeBottomSheetMenu = [
  Menu(
      menuModuleId: attendanceManagementModuleId.toString(),
      iconUrl: Utils.getImagePath("attendance1.svg"),
      title: attendanceKey),
  Menu(
    menuModuleId: timetableManagementModuleId.toString(),
    iconUrl: Utils.getImagePath("time1.svg"),
    title: timeTableKey,
  ),
  Menu(
    menuModuleId: announcementManagementModuleId.toString(),
    iconUrl: Utils.getImagePath("noticeboard_icon.svg"),
    title: noticeBoardKey,
  ),
  Menu(
      menuModuleId: examManagementModuleId.toString(),
      iconUrl: Utils.getImagePath("exam2.svg"),
      title: examsKey),
  Menu(
      menuModuleId: examManagementModuleId.toString(),
      iconUrl: Utils.getImagePath("results1.svg"),
      title: resultKey),

  //Report module is combination of assginement and exam
  Menu(
      menuModuleId:
          "$assignmentManagementModuleId$moduleIdJoiner$examManagementModuleId",
      iconUrl: Utils.getImagePath("report2.svg"),
      title: reportsKey),
  Menu(
    menuModuleId: defaultModuleId.toString(),
    iconUrl: Utils.getImagePath("parents1.svg"),
    title: guardianDetailsKey,
  ),
  Menu(
      iconUrl: Utils.getImagePath("holidays.svg"),
      title: holidaysKey,
      menuModuleId: holidayManagementModuleId.toString()),
  Menu(
      iconUrl: Utils.getImagePath("gallery2.svg"),
      title: galleryKey,
      menuModuleId: galleryManagementModuleId.toString()),
  Menu(
      iconUrl: Utils.getImagePath("settings1.svg"),
      title: settingsKey,
      menuModuleId: defaultModuleId.toString()),
];
