import 'package:eschool/data/models/guardian.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/utils/api.dart';
import 'package:eschool/utils/hiveBoxKeys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class AuthRepository {
  //LocalDataSource
  bool getIsLogIn() {
    return Hive.box(authBoxKey).get(isLogInKey) ?? false;
  }

  Future<void> setIsLogIn(bool value) async {
    return Hive.box(authBoxKey).put(isLogInKey, value);
  }

  static bool getIsStudentLogIn() {
    return Hive.box(authBoxKey).get(isStudentLogInKey) ?? false;
  }

  Future<void> setIsStudentLogIn(bool value) async {
    return Hive.box(authBoxKey).put(isStudentLogInKey, value);
  }

  static Student getStudentDetails() {
    return Student.fromJson(
      Map.from(Hive.box(authBoxKey).get(studentDetailsKey) ?? {}),
    );
  }

  Future<void> setStudentDetails(Student student) async {
    return Hive.box(authBoxKey).put(studentDetailsKey, student.toJson());
  }

  static Guardian getParentDetails() {
    return Guardian.fromJson(
      Map.from(Hive.box(authBoxKey).get(parentDetailsKey) ?? {}),
    );
  }

  Future<void> setParentDetails(Guardian parent) async {
    return Hive.box(authBoxKey).put(parentDetailsKey, parent.toJson());
  }

  String getJwtToken() {
    return Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
  }

  Future<void> setJwtToken(String value) async {
    return Hive.box(authBoxKey).put(jwtTokenKey, value);
  }

  Future<void> signOutUser() async {
    try {
      Api.post(body: {}, url: Api.logout, useAuthToken: true);
    } catch (e) {
      //
    }
    setIsLogIn(false);
    setJwtToken("");
    setStudentDetails(Student.fromJson({}));
    setParentDetails(Guardian.fromJson({}));
  }

  //RemoteDataSource
  Future<Map<String, dynamic>> signInStudent({
    required String grNumber,
    required String password,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("ttttttttttttttttttttttttttttttttttttttttttttttttt");
      print(fcmToken);
      print("ttttttttttttttttttttttttttttttttttttttttttttttttt");

      final body = {
        "password": password,
        "gr_number": grNumber,
        "fcm_id": fcmToken
      };

      final result = await Api.post(
        body: body,
        url: Api.studentLogin,
        useAuthToken: false,
      );

      return {
        "jwtToken": result['token'],
        "student": Student.fromJson(Map.from(result['data']))
      };
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> signInParent({
    required String email,
    required String password,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      final body = {
        "password": password,
        "email": email,
        "fcm_id": fcmToken,
      };

      final result =
          await Api.post(body: body, url: Api.parentLogin, useAuthToken: false);

      return {
        "jwtToken": result['token'],
        "parent": Guardian.fromJson(Map.from(result['data'] ?? {}))
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> resetPasswordRequest({
    required String grNumber,
    required DateTime dob,
  }) async {
    try {
      final body = {
        "gr_no": grNumber,
        "dob": DateFormat('yyyy-MM-dd').format(dob)
      };
      await Api.post(
        body: body,
        url: Api.requestResetPassword,
        useAuthToken: false,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newConfirmedPassword,
  }) async {
    try {
      final body = {
        "current_password": currentPassword,
        "new_password": newPassword,
        "new_confirm_password": newConfirmedPassword
      };
      await Api.post(body: body, url: Api.changePassword, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      final body = {"email": email};
      await Api.post(body: body, url: Api.forgotPassword, useAuthToken: false);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
