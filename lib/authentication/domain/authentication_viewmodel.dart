// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/authentication_data/login_info.dart';
import 'package:pos_shared_preferences/models/authentication_data/support_ticket.dart';
import 'package:pos_shared_preferences/models/authentication_data/user.dart';
import 'package:pos_shared_preferences/models/token.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/utils/mac_address_helper.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_service.dart';
import 'package:yousentech_pos_local_db/yousentech_pos_local_db.dart';
import 'package:yousentech_pos_session/pos_session/src/domain/session_service.dart';
import 'package:yousentech_pos_token/token_settings/domain/token_viewmodel.dart';
import '../utils/verification_code_helper.dart';

class AuthenticationController extends GetxController {
  final loginPinLoading = false.obs;
  final loading = false.obs;
  bool choosePin = false;
  GeneralLocalDB? _generalLocalDBinstance;

  TextEditingController pinKeyController = TextEditingController();
  static AuthenticationController? _instance;
  late AuthenticationService authenticateService;
  final TokenController _tokenController = TokenController.getInstance();

  AuthenticationController._() {
    authenticateService = AuthenticationService.getInstance();
  }

  static AuthenticationController getInstance() {
    _instance ??= AuthenticationController._();
    return _instance!;
  }

  // ========================================== [ AUTHENTICATE USING USERNAME & PASSWORD ] =============================================
  Future<ResponseResult> authenticateUsingUsernameAndPassword(
      LoginInfo loginInfo) async {
    loading.value = true;
    dynamic authResult =
        await authenticateService.authenticateUsingUsernameAndPassword(
            username: loginInfo.userName!, password: loginInfo.password!);
    if (authResult is User) {
      var checkDeviceId = await _tokenController.getDeviceIdRelatedToPos();
      // print("authResult ${authResult.allowPrintSessionReportsForOtherUsers}");

      // if (kDebugMode) {
      //   print(MacAddressHelper.macAddress);
      // }
      if (checkDeviceId.data is Token &&
          ((checkDeviceId.data as Token).macAddress ==
              MacAddressHelper.macAddress)) {
        authResult.password = loginInfo.password;
        await saveUserDataLocally(authResult: authResult);
        authResult = ResponseResult(
            status: true, message: "Successful".tr, data: authResult);

        if (authResult.data.accountLock < 3) {
          await countUsernameFailureAttempt(reset: true);
          authResult.data.accountLock = 0;
          await SharedPr.setUserObj(userObj: authResult.data);
          SessionService sessionService = SessionService.getInstance();
          await sessionService.getLastItemPosSessions();

        }
      } else if (checkDeviceId.data is Token &&
          ((checkDeviceId.data as Token).macAddress !=
              MacAddressHelper.macAddress)) {
        // if (kDebugMode) {
        //   print("un_trusted_device".tr);
        // }
        authResult = ResponseResult(message: "un_trusted_device".tr);
      } else {
        authResult = ResponseResult(message: checkDeviceId.message);
      }
    } else {
      authResult = ResponseResult(message: authResult);
    }

    loading.value = false;
    return authResult;
  }

  //  HELPER FUNCTION
  Future<void> saveUserDataLocally({required User authResult}) async {
    _generalLocalDBinstance =
        GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);
    await _generalLocalDBinstance!
        .createTable(structure: LocalDatabaseStructure.userStructure);
    Map<String, dynamic>? objToCreate = {
      'username': authResult.userName,
      'pincode': authResult.pinCode,
    };
    objToCreate.addIf(
        authResult.password != null, 'password', authResult.password);

    // print(objToCreate);
    bool userExist = await _generalLocalDBinstance!
        .checkRowExists(val: authResult.userName, whereKey: 'username');
    if (userExist) {
      await _generalLocalDBinstance!.update(
          id: authResult.userName, obj: objToCreate, whereField: 'username');
    } else {
      await _generalLocalDBinstance!.create(obj: objToCreate);
    }
  }

  // ========================================== [ AUTHENTICATE USING USERNAME & PASSWORD ] =============================================

  // ========================================== [ authenticate Using PIN ] =============================================
  Future<ResponseResult> authenticateUsingPIN({required String pinCode}) async {
    loginPinLoading.value = true;
    var result =
        await authenticateService.authenticateUsingPIN(pinCode: pinCode);
    if (result is User) {
      var checkDeviceId = await _tokenController.getDeviceIdRelatedToPos();
      if (checkDeviceId.data is Token &&
          ((checkDeviceId.data as Token).macAddress ==
              MacAddressHelper.macAddress)) {
        await saveUserDataLocally(authResult: result);
        // to save user info
        await SharedPr.setUserObj(userObj: result);
        SessionService sessionService = SessionService.getInstance();
        await sessionService.getLastItemPosSessions();
        loginPinLoading.value = false;
        return ResponseResult(status: true, data: result);
      } else {
        loginPinLoading.value = false;
        return ResponseResult(message: "un_trusted_device".tr);
      }
    } else if (result == null) {
      loginPinLoading.value = false;
      return ResponseResult(message: "user_not_found".tr);
    } else if (result is SocketException) {
      loginPinLoading.value = false;
      return ResponseResult(message: "no_connection".tr);
    } else {
      loginPinLoading.value = false;
      SharedPr.setErrorAuthentication();
      update();
      return ResponseResult(message: result);
    }
  }

  // ========================================== [ authenticate Using PIN] =============================================

  // ========================================== [ restart Erro rAuthentication] =============================================
  void restartErrorAuthentication() {
    SharedPr.removeErrorAuthentication();
    update();
  }

  // ========================================== [ restart Erro rAuthentication] =============================================

  // ========================================== [forget Password] =============================================
  Future<ResponseResult> forgetPassword() async {
    loading.value = true;
    String code = VerificationCodeGeneratorHelper.generateCode();
    var result = await authenticateService.forgetPassword(
        userId: SharedPr.chosenUserObj!.id.toString(),
        verificationNumber: code);
    if (result is bool && result == true) {
      SharedPr.setForgetPass(flage: true, otp: code);
      update();
      loading.value = false;
      return ResponseResult(status: true, message: "send_otp".tr);
    } else {
      loading.value = false;
      return ResponseResult(message: result["message"]);
    }
  }

  // ========================================== [ forget Password] =============================================
  // ===========================================================================================================

  // ========================================== [ CHANGE PASSWORD ] =============================================
  Future<ResponseResult> changePassword({required String password}) async {
    loading.value = true;
    var authResult =
        await authenticateService.changePassword(password: password);
    loading.value = false;

    if (authResult is bool && authResult == true) {
      return ResponseResult(status: true, message: "Successful".tr);
    } else {
      return ResponseResult(message: authResult);
    }
  }

  // ========================================== [ CHANGE PASSWORD ] =============================================

  // ========================================== [ ACTIVATE PIN LOGIN ] =============================================
  Future<ResponseResult> activatePinLogin({required String pinCode}) async {
    loading.value = true;
    var authResult =
        await authenticateService.activatePinLogin(pinCode: pinCode);
    loading.value = false;

    // print(authResult);
    if (authResult is bool && authResult == true) {
      await UpdateUserDataLocally(pinCode);
      // TODO : DID YOU NEED IT HERE ?????
      //  await _generalLocalDBinstance!.index();
      SharedPr.setForgetPass(flage: false, otp: '');
      update();
      return ResponseResult(status: true, message: "Successful".tr);
    } else {
      return ResponseResult(message: authResult);
    }
  }

  Future<void> UpdateUserDataLocally(String pincode) async {
    _generalLocalDBinstance =
        GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);

    await _generalLocalDBinstance!.update(
        id: SharedPr.userObj!.userName,
        obj: {
          'pincode': pincode,
        },
        whereField: 'username');
  }

// ========================================== [ ACTIVATE PIN LOGIN ] =============================================

  // ========================================== [ Set PIN Key] =============================================
  void setPinKey({isClear = false, required String data}) {
    if (isClear) {
      if (data == "Backspace" && pinKeyController.text.isNotEmpty) {
        pinKeyController.text = pinKeyController.text
            .substring(0, pinKeyController.text.length - 1);
        update();
      } else {
        pinKeyController.clear();
        update();
      }
    } else {
      pinKeyController.text = pinKeyController.text + data;
      update();
    }
  }

// ========================================== [ Set PIN Key] =============================================
//
// ========================================== [ Count Username Failure Attempt] =============================================
  Future<ResponseResult> countUsernameFailureAttempt(
      {bool reset = false}) async {
    loading.value = true;
    var countResult =
        await authenticateService.countUsernameFailureAttempt(reset: reset);

    loading.value = false;
    if (countResult is bool && countResult == true) {
      return ResponseResult(status: true);
    } else {
      return ResponseResult(message: countResult);
    }
  }

// ========================================== [ Count Username Failure Attempt] =============================================

// ========================================== [ Count PIN Failure Attempt] =============================================
  Future<ResponseResult> sendTicketToEliminateAccountLock() async {
    loading.value = true;
    var ticketResult =
        await authenticateService.sendTicketToEliminateAccountLock();
    loading.value = false;

    if (ticketResult is int && ticketResult != 0) {
      return ResponseResult(status: true);
    } else {
      return ResponseResult(message: ticketResult);
    }
  }

// ========================================== [ Set PIN Key] =============================================
  Future<ResponseResult> countPINFailureAttempt({bool reset = false}) async {
    // final loading = false.obs;
    // loading.value = true;
    loginPinLoading.value = true;
    var countResult = await authenticateService.countPINFailureAttempt();
    loginPinLoading.value = false;
    // loading.value = false;

    if (countResult is bool && countResult == true) {
      return ResponseResult(status: true);
    } else {
      return ResponseResult(message: countResult);
    }
  }

// ========================================== [ Set PIN Key] =============================================

  void setChoosePin() {
    choosePin = !choosePin;
    update(["choosePin"]);
  }

  Future<ResponseResult> getUserAccountLockTicket() async {
    // loading.value = true;
    var ticketResult = await authenticateService.getUserAccountLockTicket();
    // loading.value = false;
    if (ticketResult is SupportTicket) {
      return ResponseResult(status: true, data: ticketResult);
    }
    if (ticketResult is List) {
      return ResponseResult(status: true, data: ticketResult);
    } else {
      return ResponseResult(message: ticketResult);
    }
  }

  Future<ResponseResult> updateUserAccountLockStatusTicket(
      {required int id}) async {
    // loading.value = true;
    var ticketResult =
        await authenticateService.updateUserAccountLockStatusTicket(id: id);
    // loading.value = false;
    if (ticketResult is bool && ticketResult) {
      return ResponseResult(status: true, data: ticketResult);
    } else {
      return ResponseResult(message: ticketResult);
    }
  }
}
