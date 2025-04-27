import 'package:get/get.dart';
import 'package:shared_widgets/config/app_shared_pr.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_pos_dashboard/dashboard/src/presentation/views/home_page.dart';

void subMitPIN({required AuthenticationController authenticationController}) async {
  if (authenticationController.pinKeyController.text.isNotEmpty) {
    // if(authenticationController.pinKeyController.text != SharedPr.chosenUserObj!.pinCode) {
    //   appSnackBar(message: 'user_does_not_match'.trParams({'field_name' : 'pin_code'.tr}));
    //   return;
    // }
    if (SharedPr.chosenUserObj!.pinCodeLock! >= 3) {
      authenticationController.setChoosePin();
      appSnackBar(
        message: 'pin_code_locked'.tr,
      );
    }
    if (SharedPr.chosenUserObj!.accountLock! == 3) {
      appSnackBar(
        message: 'account_locked'.tr,
      );
    } else {
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
          if (value.message == "un_trusted_device".tr) {
            appSnackBar(
              message: value.message,
            );
            authenticationController.loading.value = false;
            return;
          } else if (value.message ==
              "sign_in_using_username_at_least_one_time".tr) {
            appSnackBar(
              message: value.message,
            );
            authenticationController.loading.value = false;
            return;
          } 
          else if (value.message =="no_connection".tr) {
            appSnackBar(
              message: value.message,
            );
            authenticationController.loading.value = false;
            return;
          }
          else {
            if (SharedPr.chosenUserObj!.pinCodeLock! < 3) {
              await SharedPr.updatePinCodeLockCountLocally();
              await authenticationController.countPINFailureAttempt();
            }
            appSnackBar(
              message: SharedPr.chosenUserObj!.pinCodeLock! < 3
                  ? 'unsuccessful_login'.trParams({
                      "field_name":
                          "${3 - SharedPr.chosenUserObj!.pinCodeLock!}"
                    })
                  : 'pin_code_locked'.tr,
            );
            authenticationController.loading.value = false;
          }
        }
      });
    }
  } else {
    appSnackBar(
      message: 'required_message'.trParams({'field_name': 'pin_number'.tr}),
    );
  }
}
