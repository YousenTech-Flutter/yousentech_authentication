import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';
import 'package:shared_widgets/utils/validator_helper.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/utils/login_helper.dart';

TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
AuthenticationController authenticationController = Get.put(
  AuthenticationController.getInstance(),
);
final _formKey = GlobalKey<FormState>();
String? errorMessage;
int countErrors = 0;
bool flagPass = false;
bool flagConfirm = false;

changePasswordDialog({required BuildContext context}) {
  passwordController.clear();
  confirmPasswordController.clear();
  dialogcontent(
    context: Get.context!,
    content: Builder(
      builder: (context) {
        return SizeProvider(
          baseSize: Size(context.setWidth(454.48), context.setHeight(350)),
          width: context.setWidth(454.48),
          height: context.setHeight(350),
          child: Obx(
            () => IgnorePointer(
              ignoring: authenticationController.loading.value,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: context.setWidth(80),
                  height: context.setHeight(350),
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(context.setMinSize(20)),
                          child: Column(
                            spacing: context.setHeight(10),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "change_password".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: SharedPr.isDarkMode!
                                      ? Colors.white
                                      : const Color(0xFF2E2E2E),
                                  fontSize: context.setSp(16),
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.password_rounded,
                                color: AppColor.amberLight,
                                size: context.setMinSize(50),
                              ),
                              Text(
                                "enter_your_new_password".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: SharedPr.isDarkMode!
                                      ? Colors.white
                                      : const Color(0xFF2E2E2E),
                                  fontSize: context.setSp(14),
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: context.setHeight(10)),
                              StatefulBuilder(
                                builder: (BuildContext context, setState) {
                                  return ContainerTextField(
                                    controller: passwordController,
                                    width: context.screenWidth,
                                    height: context.setHeight(51.28),
                                    borderColor: !SharedPr.isDarkMode!
                                        ? Color(0xFFC2C3CB)
                                        : null,
                                    fillColor: !SharedPr.isDarkMode!
                                        ? Colors.white.withValues(
                                            alpha: 0.43,
                                          )
                                        : const Color(0xFF2B2B2B),
                                    hintcolor: !SharedPr.isDarkMode!
                                        ? Color(0xFF585858)
                                        : const Color(0xFFC2C3CB),
                                    color: !SharedPr.isDarkMode!
                                        ? Color(0xFF585858)
                                        : const Color(0xFFC2C3CB),
                                    isAddOrEdit: true,
                                    borderRadius: context.setMinSize(5),
                                    fontSize: context.setSp(12),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(
                                        context.setMinSize(8),
                                      ),
                                      child: SvgPicture.asset(
                                        AppImages.lockOn,
                                        package: 'shared_widgets',
                                        fit: BoxFit
                                            .scaleDown, // Adjust this to control scaling
                                      ),
                                    ),
                                    hintText: 'password'.tr,
                                    labelText: 'password'.tr,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            flagPass = !flagPass;
                                          });
                                        },
                                        icon: flagPass
                                            ? SvgPicture.asset(
                                                AppImages.eyeOpen,
                                                package: 'shared_widgets',
                                                
                                                fit: BoxFit.scaleDown,
                                                color: AppColor.silverGray,
                                                // Adjust this to control scaling
                                              )
                                            : SvgPicture.asset(
                                              AppImages.eyeClosed,
                                              package: 'shared_widgets',
                                                fit: BoxFit
                                                    .scaleDown, // Adjust this to control scaling
                                              ),
                                      ),
                                    ),
                                    obscureText: flagPass ? false : true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        errorMessage =
                                            'required_message_f'.trParams({
                                          'field_name': 'password'.tr,
                                        });
                                        countErrors++;
                                        return "";
                                      } else if (value.isNotEmpty) {
                                        var message =
                                            ValidatorHelper.passWordValidation(
                                          value: value,
                                        );
                                        if (message == "") {
                                          return null;
                                        }
                                        errorMessage = message;
                                        return "";
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: context.setHeight(10)),
                              StatefulBuilder(
                                builder: (BuildContext context, setState) {
                                  return ContainerTextField(
                                    controller: confirmPasswordController,
                                    width: context.screenWidth,
                                    height: context.setHeight(51.28),
                                    borderColor: !SharedPr.isDarkMode!
                                        ? Color(0xFFC2C3CB)
                                        : null,
                                    fillColor: !SharedPr.isDarkMode!
                                        ? Colors.white.withValues(
                                            alpha: 0.43,
                                          )
                                        : const Color(0xFF2B2B2B),
                                    hintcolor: !SharedPr.isDarkMode!
                                        ? Color(0xFF585858)
                                        : const Color(0xFFC2C3CB),
                                    color: !SharedPr.isDarkMode!
                                        ? Color(0xFF585858)
                                        : const Color(0xFFC2C3CB),
                                    isAddOrEdit: true,
                                    borderRadius: context.setMinSize(5),
                                    fontSize: context.setSp(12),
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(
                                        context.setMinSize(8),
                                      ),
                                      child: SvgPicture.asset(
                                        AppImages.lockOn,
                                        package: 'shared_widgets',
                                        fit: BoxFit
                                            .scaleDown, // Adjust this to control scaling
                                      ),
                                    ),
                                    hintText: 'confirm_password'.tr,
                                    labelText: 'confirm_password'.tr,
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            flagConfirm = !flagConfirm;
                                          });
                                        },
                                        icon: flagConfirm
                                            ? SvgPicture.asset(
                                                AppImages.eyeOpen,
                                                package: 'shared_widgets',
                                                
                                                fit: BoxFit.scaleDown,
                                                
                                                color: AppColor.silverGray,
                                                // Adjust this to control scaling
                                              )
                                            : SvgPicture.asset(
                                              AppImages.eyeClosed,
                                              package: 'shared_widgets',
                                                
                                                fit: BoxFit
                                                    .scaleDown, // Adjust this to control scaling
                                              ),
                                      ),
                                    ),
                                    obscureText: flagConfirm ? false : true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        errorMessage =
                                            'required_message_f'.trParams({
                                          'field_name': 'confirm_password'.tr,
                                        });
                                        countErrors++;
                                        return "";
                                      } else if (value !=
                                          passwordController.text) {
                                        errorMessage = 'un_match_password'.tr;
                                        return "";
                                      } else if (value.isNotEmpty) {
                                        var message =
                                            ValidatorHelper.passWordValidation(
                                          value: value,
                                        );
                                        if (message == "") {
                                          return null;
                                        }
                                        errorMessage = message;
                                        return "";
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              Spacer(),
                              Row(
                                spacing: context.setWidth(10),
                                children: [
                                  Expanded(
                                    child: ButtonElevated(
                                      text: "change_password".tr,
                                      height: context.setHeight(35),
                                      borderRadius: context.setMinSize(5),
                                      backgroundColor: AppColor.cyanTeal,
                                      showBoxShadow: true,
                                      textStyle: AppStyle.textStyle(
                                        color: Colors.white,
                                        fontSize: context.setSp(12),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      onPressed: () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          appSnackBar(
                                            message: countErrors > 1
                                                ? 'enter_required_info'.tr
                                                : errorMessage,
                                          );
                                          return;
                                        }
                                        countErrors = 0;
                                        LoginHelper.changePassword(
                                          authenticationController:
                                              authenticationController,
                                          formKey: _formKey,
                                          errorMessage: errorMessage,
                                          countErrors: countErrors,
                                          password: passwordController.text,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: ButtonElevated(
                                      text: 'cancel'.tr,
                                      height: context.setHeight(35),
                                      borderRadius: context.setMinSize(5),
                                      borderColor: AppColor.paleAqua,
                                      textStyle: AppStyle.textStyle(
                                        color: AppColor.slateGray,
                                        fontSize: context.setSp(12),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      onPressed: () async {
                                        Get.back();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      authenticationController.loading.value
                          ? const LoadingWidget()
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
