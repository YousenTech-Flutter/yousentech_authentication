import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_pos_dashboard/dashboard/src/presentation/views/home_page.dart';

void subMitPIN({required AuthenticationController authenticationController}) async {
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
      Get.to(() => const HomePage());
    } else {
      // if (value.message == "un_trusted_device".tr || value.message =="sign_in_using_username_at_least_one_time".tr || value.message =="no_connection".tr  || value.message == 'failed_connect_server'.tr) {
      //   appSnackBar(
      //     message: value.message,
      //   );
      //   authenticationController.loading.value = false;
      //   return;
      // }
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
