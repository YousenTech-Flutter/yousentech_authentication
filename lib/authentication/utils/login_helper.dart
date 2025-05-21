import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pos_localbackup/local_backup/config/app_enum.dart';
import 'package:pos_localbackup/local_backup/utils/local_backup_prompt.dart';
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
import 'package:yousentech_pos_dashboard/dashboard/src/presentation/views/home_page.dart';

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
      }) async {
    if (!formKey.currentState!.validate()) {
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
      return;
    }
    ResponseResult responseResult = await authenticationController
        .changePassword(password: passwordController.text);
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
        changePasswordDialog();
        return;
      }
      if (SharedPr.localBackUpSettingObj?.backupSavePth != null &&
          SharedPr.localBackUpSettingObj!.selectedOption ==
              BackUpOptions.backup_on_login.name) {
        await showLocalBackupPrompt();
      }
      Get.to(() => const HomePage());
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
        showAccountLockDialog();
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
}
