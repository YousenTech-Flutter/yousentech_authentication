// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  // Functionality:
  //   - Authenticates the user using provided credentials via the authentication service.
  //   - Verifies that the device used matches the trusted MAC address.
  //   - If authenticated and the device is trusted, saves user data locally and resets failure attempts.
  //   - If the device is untrusted or an error occurs, returns an appropriate message.
  // Input:
  //   - loginInfo: Contains username and password for authentication.
  // Returns:
  //   - ResponseResult: Contains the authentication status, message, and user data if successful.
  Future<ResponseResult> authenticateUsingUsernameAndPassword(
      LoginInfo loginInfo) async {
    loading.value = true;
    dynamic authResult =
        await authenticateService.authenticateUsingUsernameAndPassword(
            username: loginInfo.userName!, password: loginInfo.password!);
    if (authResult is User) {
      var checkDeviceId = await _tokenController.getDeviceIdRelatedToPos();
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
// ========================================== [ AUTHENTICATE USING USERNAME & PASSWORD ] =============================================

// ===================================================== [Save User Data Locally] =====================================================
  // Functionality:
  //   - Initializes the local database instance for the User model.
  //   - Creates the user table if it doesn't already exist.
  //   - Prepares a user object containing essential fields (username, pincode, optional password).
  //   - Checks if a user record already exists in the local DB and either updates or inserts accordingly.
  // Input:
  //   - authResult: A User object .
  // Returns:
  //   - Update user Table in DB
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
    bool userExist = await _generalLocalDBinstance!
        .checkRowExists(val: authResult.userName, whereKey: 'username');
    if (userExist) {
      await _generalLocalDBinstance!.update(
          id: authResult.userName, obj: objToCreate, whereField: 'username');
    } else {
      await _generalLocalDBinstance!.create(obj: objToCreate);
    }
  }
// ===================================================== [Save User Data Locally] =====================================================

// ===================================================== [Authenticate Using PIN Code] =====================================================
  // Functionality:
  //   - Authenticates a user using their PIN code via the authentication service.
  //   - Verifies that the device used matches the trusted MAC address.
  //   - On success: saves user data locally, sets session data, and update or save User Obj  in shared preferences.
  //   - Handles different failure scenarios like user not found, no connection, or general error.
  // Input:
  //   - pinCode (required).
  // Returns:
  //   - ResponseResult: Contains authentication status, user data if successful, or an error message.
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
    } else {
      loginPinLoading.value = false;
      if(result is String && (result != "no_connection".tr || result != 'failed_connect_server'.tr)){
        SharedPr.setErrorAuthentication();
      }
      update();
      return ResponseResult(message: result);
    }
  }
// ===================================================== [Authenticate Using PIN Code] =====================================================

// ===================================================== [Restart Error Authentication State] =====================================================
  // Functionality:
  //   - Clears any stored error authentication flags from shared preferences.
  //   - Triggers a UI update to reflect the reset authentication state.
  void restartErrorAuthentication() {
    SharedPr.removeErrorAuthentication();
    update();
  }
// ===================================================== [Restart Error Authentication State] =====================================================

// ===================================================== [Forget Password] =====================================================
  // Functionality:
  //   - Generates a verification code (OTP) for password recovery.
  //   - Sends the OTP to the server using the authenticated user ID.
  //   - On success, stores the OTP and forget-password flag in shared preferences.
  //   - Triggers a UI update and resets the loading state.
  // Input:
  //   - None (uses the currently chosen user from shared preferences)
  // Returns:
  //   - ResponseResult: Status and message indicating success or failure.
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
// ===================================================== [Forget Password] =====================================================

// ===================================================== [Change User Password] =====================================================
  // Functionality:
  //   - Sends a request to update the user's password via the authentication service.
  //   - Updates the loading state during the request lifecycle.
  //   - Returns a success message if the password was changed successfully, otherwise returns the error message.
  // Input:
  //   - password (required): The new password to be set.
  // Returns:
  //   - ResponseResult: Indicates whether the password change was successful or not.
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
// ========================================== [Change User Password] ] =============================================

// ===================================================== [Activate PIN Login] =====================================================
  // Functionality:
  //   - Activates PIN login by sending the provided PIN code to the authentication service.
  //   - If successful, updates the local user data with the new PIN code.
  //   - Clears any forget-password state from shared preferences.
  //   - Updates the UI state.
  // Input:
  //   - pinCode (required): The new PIN code to be activated for login.
  // Returns:
  //   - ResponseResult: Indicates success or provides an error message.
  Future<ResponseResult> activatePinLogin({required String pinCode}) async {
    loading.value = true;
    var authResult =
        await authenticateService.activatePinLogin(pinCode: pinCode);
    loading.value = false;
    if (authResult is bool && authResult == true) {
      await updateUserDataLocally(pinCode);
      SharedPr.setForgetPass(flage: false, otp: '');
      update();
      return ResponseResult(status: true, message: "Successful".tr);
    } else {
      return ResponseResult(message: authResult);
    }
  }
// ===================================================== [Activate PIN Login] =====================================================

// ===================================================== [Update User Data Locally] =====================================================
  // Functionality:
  //   - Updates the user's PIN code in the local database.
  //   - The user is identified by their username, which is stored in shared preferences.
  // Input:
  //   - pincode (required): The new PIN code to be updated for the user.
  // Returns:
  //   - Future<void>: This method does not return any value but performs an update operation in the local DB.
  Future<void> updateUserDataLocally(String pincode) async {
    _generalLocalDBinstance =
        GeneralLocalDB.getInstance<User>(fromJsonFun: User.fromJson);

    await _generalLocalDBinstance!.update(
        id: SharedPr.userObj!.userName,
        obj: {
          'pincode': pincode,
        },
        whereField: 'username');
  }
// ===================================================== [Update User Data Locally] =====================================================

// ===================================================== [Set PIN Key] =====================================================
  // Functionality:
  //   - Handles the input or clearing of the PIN key based on the provided flag.
  //   - If `isClear` is true, the method clears or removes the last character of the PIN key based on the 'data'.
  //   - If `isClear` is false, the method appends the provided data to the PIN key.
  // Input:
  //   - isClear (optional, default false): Flag to indicate whether to clear or modify the PIN.
  //   - data (required): The key data (e.g., a number or "Backspace") to be added or removed from the PIN.
  // Returns:
  //   - Updates the `pinKeyController` text and triggers a UI update.
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

// ===================================================== [Count Username Failure Attempt] =====================================================
  // Functionality:
  //   - Counts the number of failed username login attempts or resets the counter based on the provided flag.
  //   - The reset flag determines whether to reset the failure count or just retrieve it.
  // Input:
  //   - reset (optional, default false): Flag to reset the failure count. If true, resets the count; otherwise, just retrieves the count.
  // Returns:
  //   - ResponseResult: Indicates whether the operation was successful or not with a message in case of failure.
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
// ===================================================== [Count Username Failure Attempt] =====================================================

// ===================================================== [Send Ticket to Eliminate Account Lock] =====================================================
  // Functionality:
  //   - Sends a request to the authentication service to eliminate the account lock.
  //   - The service responds with a result that indicates success or failure.
  // Input:
  //   - None
  // Returns:
  //   - ResponseResult: Returns a status indicating success or failure with an appropriate message.
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
// ===================================================== [Send Ticket to Eliminate Account Lock] =====================================================

// ===================================================== [Count PIN Failure Attempt] =====================================================
  // Functionality:
  //   - Counts the number of failed PIN login attempts or resets the counter based on the provided flag.
  //   - The reset flag determines whether to reset the failure count or just retrieve it.
  // Input:
  //   - reset (optional, default false): Flag to reset the failure count. If true, resets the count; otherwise, just retrieves the count.
  // Returns:
  //   - ResponseResult: Indicates whether the operation was successful or not with a message in case of failure.
  Future<ResponseResult> countPINFailureAttempt({bool reset = false}) async {
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
// ===================================================== [Count PIN Failure Attempt] =====================================================

// ===================================================== [Set Choose PIN] =====================================================
  // Functionality:
  //   - Toggles the state of the 'choosePin' flag and updates the UI accordingly.
  //   - The flag is used to indicate whether the user has switch to  (pin or username) login.
  // Input
  //   - None
  // Returns:
  //   - void: This method updates the state and triggers a UI update.
  void setChoosePin() {
    choosePin = !choosePin;
    update(["choosePin"]);
  }
// ===================================================== [Set Choose PIN] =====================================================

// ===================================================== [Get User Account Lock Ticket] =====================================================
  // Functionality:
  //   - Retrieves the support ticket related to the user's account lock.
  //   - The method checks whether the response is a valid support ticket or a list of tickets and returns accordingly.
  // Input:
  //   - None
  // Returns:
  //   - ResponseResult: Contains the status of the operation along with the ticket data or an error message if the request fails.
  Future<ResponseResult> getUserAccountLockTicket() async {
    var ticketResult = await authenticateService.getUserAccountLockTicket();
    if (ticketResult is SupportTicket) {
      return ResponseResult(status: true, data: ticketResult);
    }
    if (ticketResult is List) {
      return ResponseResult(status: true, data: ticketResult);
    } else {
      return ResponseResult(message: ticketResult);
    }
  }
// ===================================================== [Get User Account Lock Ticket] =====================================================

// ===================================================== [Update User Account Lock Status Ticket] =====================================================
  // Functionality:
  //   - Updates the status of a user account lock to (`true` locked accout) based on the provided ticket ID.
  //   - The method communicates with the authentication service to update the lock status and returns the result.
  // Input:
  //   - id (required): The ID of the support ticket associated with the account lock.
  // Returns:
  //   - ResponseResult: Contains the status of the operation, either success or failure, along with a message or data.
  Future<ResponseResult> updateUserAccountLockStatusTicket(
      {required int id}) async {
    var ticketResult =
        await authenticateService.updateUserAccountLockStatusTicket(id: id);
    if (ticketResult is bool && ticketResult) {
      return ResponseResult(status: true, data: ticketResult);
    } else {
      return ResponseResult(message: ticketResult);
    }
  }
// ===================================================== [Update User Account Lock Status Ticket] =====================================================
}
