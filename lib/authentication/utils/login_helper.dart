
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/authentication_data/login_info.dart';
import 'package:pos_shared_preferences/models/notification_helper_model.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:remote_database_setting/remote_database_setting/domain/remote_database_setting_viewmodel.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/presentation/views/login_screen.dart';
import 'package:yousentech_authentication/authentication/presentation/views/username_password_login_screen.dart';
import 'package:yousentech_authentication/authentication/presentation/widgets/change_password_screen.dart';

class LoginHelper {
  static Future forgetPassword({required AuthenticationController authenticationController}) async {
    ResponseResult responseResult =
        await authenticationController.forgetPassword();
    Get.back();
    if (responseResult.status) {
      appSnackBar(
          message: responseResult.message, messageType: MessageTypes.success);
      return;
    }
    showPassWordErrorDialog(message: responseResult.message);
  }

  static Future changePassword(
      {required AuthenticationController authenticationController,
      required GlobalKey<FormState> formKey,
      required String? errorMessage,
      required int countErrors,
      required String password
      }) async {
    if (!formKey.currentState!.validate()) {
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
      return;
    }
    ResponseResult responseResult = await authenticationController
        .changePassword(password: password);
    if (responseResult.status) {
      Get.offAll(() => const LoginScreen());
      await SharedPr.removeUserObj();
    }
    appSnackBar(
      messageType:
          responseResult.status ? MessageTypes.success : MessageTypes.error,
      message: responseResult.message,
    );
  }

  static Future authenticateUsingUsernameAndPassword({
    required GlobalKey<FormState> formKey,
    String? errorMessage,
    required int countErrors,
    required AuthenticationController authenticationController,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required BuildContext context,
  }) async {
    if (!formKey.currentState!.validate()) {
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage,
      );
      return;
    }
    ResponseResult responseResult = await authenticationController
        .authenticateUsingUsernameAndPassword(LoginInfo(
            userName: usernameController.text,
            password: passwordController.text));
    if (responseResult.status && responseResult.data.accountLock < 3) {
      if (SharedPr.isForgetPass!) {
        await authenticationController.countUsernameFailureAttempt(reset: true);
        responseResult.data.accountLock = 0;
        await SharedPr.setUserObj(userObj: responseResult.data);
        await SharedPr.setForgetPass(flage: false, otp: '');
        // ignore: use_build_context_synchronously
        changePasswordDialog(context:context );
        return;
      }
      // if (SharedPr.localBackUpSettingObj?.backupSavePth != null &&
      //     SharedPr.localBackUpSettingObj!.selectedOption ==
      //         BackUpOptions.backup_on_login.name) {
      //   await showLocalBackupPrompt();
      // }
      Get.off(() => Home());
      // Get.off(() => const DashboardScreen());
      appSnackBar(
        messageType: MessageTypes.success,
        message: responseResult.message,
      );
    } else {
      if (responseResult.message == 'login_information_incorrect'.tr) {
        if (SharedPr.chosenUserObj!.accountLock! < 3) {
          await SharedPr.updateAccountLockCountLocally();
          await authenticationController.countUsernameFailureAttempt();
          if (SharedPr.chosenUserObj!.accountLock! < 3) {
            appSnackBar(
                message: 'unsuccessful_login'.trParams({
              "field_name":
                  "${(3 - SharedPr.chosenUserObj!.accountLock!) == 0 ? 'account_locked'.tr : 3 - SharedPr.chosenUserObj!.accountLock!}"
            }));
            return;
          }
        }
        // ignore: use_build_context_synchronously
        showAccountLockDialog(authenticationController: authenticationController, context: context);
        return;
      }
      appSnackBar(message: responseResult.message);
      authenticationController.loading.value = false;
      return;
    }
  }

  static Future sendTicketToEliminateAccountLock(
      {required AuthenticationController authenticationController}) async {
    var result =
        await authenticationController.sendTicketToEliminateAccountLock();
    if (result.status) {
      SharedPr.setNotificationObj(
          notificationHelperObj: NotificationHelper(accountLock: true));
    }
    Get.back();
    appSnackBar(
        messageType: result.status ? MessageTypes.success : MessageTypes.error,
        message: result.status
            ? 'success_send_ticket'.tr
            : 'send_ticket_already'.tr);
  }

  static Future sendTicket({
    required DatabaseSettingController databaseSettingController,
    required String message,
  }) async {
    await databaseSettingController
        .sendTicket(
            subscriptionId:
                SharedPr.subscriptionDetailsObj!.subscriptionId.toString(),
            message: message)
        .then((value) {
      if (value.status) {
        SharedPr.setNotificationObj(
            notificationHelperObj: NotificationHelper(sendTicket: true));
        Get.back();
      }
      appSnackBar(
          message: value.status ? 'success_send_ticket'.tr : value.message!,
          messageType:
              value.status ? MessageTypes.success : MessageTypes.error);
    });
  }

  static Future activatePinLogin(
      {required AuthenticationController authenticationController,
      required GlobalKey<FormState> formKey,
      required TextEditingController pinCodeController,
      required String? errorMessage,
      required int countErrors,
      bool isSkipValidate = false}) async {
    if (!isSkipValidate) {
      if (!formKey.currentState!.validate()) {
        appSnackBar(
          message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
        );
        return;
      }
    }

    ResponseResult responseResult = await authenticationController.activatePinLogin(pinCode: pinCodeController.text);
    await SharedPr.updatePinCodeValue(pinCode: pinCodeController.text);
    if (!isSkipValidate) {
      if (responseResult.status) {
        Get.offAll(() => const LoginScreen());
        await SharedPr.removeUserObj();
      }
    }
    appSnackBar(
      messageType:responseResult.status ? MessageTypes.success : MessageTypes.error,
      message: responseResult.message,
    );
    if (isSkipValidate) {
      return;
    }
  }



  static  void subMitPIN({required AuthenticationController authenticationController}) async {
  if (authenticationController.pinKeyController.text.isEmpty) {
    appSnackBar(
      message: 'required_message'.trParams({'field_name': 'pin_number'.tr}),
    );
    return;
  }

  if (SharedPr.chosenUserObj!.pinCodeLock! >= 3) {
    authenticationController.setChoosePin();
    appSnackBar(
      message: 'pin_code_locked'.tr,
    );
    return;
  } else if (SharedPr.chosenUserObj!.accountLock! == 3) {
    appSnackBar(
      message: 'account_locked'.tr,
    );
    return;
  }
  authenticationController.loading.value = true;
  await authenticationController
      .authenticateUsingPIN(
          pinCode: authenticationController.pinKeyController.text)
      .then((value) async {
    if (value.status) {
      if (SharedPr.chosenUserObj!.accountLock! < 3) {
        await SharedPr.updateAccountLockCountLocally(reset: true);
      }
      await SharedPr.updatePinCodeLockCountLocally(reset: true);
      await authenticationController.countPINFailureAttempt(reset: true);
      authenticationController.pinKeyController.clear();
      authenticationController.loading.value = false;
      Get.to(() =>  InvoiceHome());
    } else {
      if (value.message != "user_not_found".tr) {
        appSnackBar(
          message: value.message,
        );
        authenticationController.loading.value = false;
        return;
      }
      if (SharedPr.chosenUserObj!.pinCodeLock! < 3) {
        await SharedPr.updatePinCodeLockCountLocally();
        await authenticationController.countPINFailureAttempt();
      }
      appSnackBar(
        message: SharedPr.chosenUserObj!.pinCodeLock! < 3
            ? 'unsuccessful_login'.trParams(
                {"field_name": "${3 - SharedPr.chosenUserObj!.pinCodeLock!}"})
            : 'pin_code_locked'.tr,
      );
      authenticationController.loading.value = false;
    }
  });
}

}
