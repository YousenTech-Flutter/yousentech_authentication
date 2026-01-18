// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/config/app_theme.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import '../../../authentication/presentation/views/login_screen.dart';

TextEditingController pinCodeController = TextEditingController();
TextEditingController confirmPinCodeController = TextEditingController();
AuthenticationController authenticationController = Get.put(
  AuthenticationController.getInstance(),
);

activatePINLogin({bool enable = true, required BuildContext context}) async {
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  int countErrors = 0;
  bool flagPin = false;
  bool flagConfirm = false;
  pinCodeController.clear();
  confirmPinCodeController.clear();

  if (!enable) {
    ResponseResult responseResult =
        await authenticationController.activatePinLogin(pinCode: '');
    SharedPr.updatePinCodeValue(pinCode: null);
    appSnackBar(
      messageType: MessageTypes.success,
      message: responseResult.message,
    );
    return;
  }
  onPressed() async {
    countErrors = 0;
    if (_formKey.currentState!.validate()) {
      ResponseResult responseResult = await authenticationController
          .activatePinLogin(pinCode: pinCodeController.text);
      await SharedPr.updatePinCodeValue(pinCode: pinCodeController.text);
      if (responseResult.status) {
        Get.offAll(() => const LoginScreen());
        await SharedPr.removeUserObj();
      }
      appSnackBar(
        messageType: MessageTypes.success,
        message: responseResult.message,
      );
    } else {
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
    }
  }

  dialogcontent(
    context: context,
    content: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          onPressed();
        }
      },
      child: Builder(
        builder: (context) {
          return SizeProvider(
            baseSize: Size(context.setWidth(454.48), context.setHeight(360)),
            width: context.setWidth(454.48),
            height: context.setHeight(360),
            child: Obx(
              () => IgnorePointer(
                ignoring: authenticationController.loading.value,
                child: SizedBox(
                  width: context.setWidth(454.48),
                  height: context.setHeight(360),
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
                                'enable_pin_login'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? AppColor.white
                                      : AppColor.black,
                                  fontSize: context.setSp(16),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.pin,
                                color: AppColor.amberLight,
                                size: context.setMinSize(50),
                              ),
                              Text(
                                'enter_pin_code'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: context.setSp(14),
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? AppColor.white
                                      : AppColor.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: context.setHeight(10),
                              ),
                              StatefulBuilder(
                                builder: (BuildContext statefulBuilderContext,
                                    setState) {
                                  return ContainerTextField(
                                    controller: pinCodeController,
                                    width: context.screenWidth,
                                    height: context.setHeight(51.28),
                                    borderColor: const Color(0xFFC2C3CB),
                                    fillColor: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF2B2B2B)
                                        : Colors.white.withValues(alpha: 0.43),
                                    hintcolor: const Color(0xFFC2C3CB),
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? AppColor.white
                                        : AppColor.black,
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
                                    hintText: 'pin_code'.tr,
                                    labelText: 'pin_code'.tr,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            flagPin = !flagPin;
                                          });
                                        },
                                        icon: flagPin
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
                                    obscureText: flagPin ? false : true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        errorMessage =
                                            'required_message'.trParams({
                                          'field_name': 'pin_code'.tr,
                                        });
                                        countErrors++;
                                        return "";
                                      } else if (value.length < 4) {
                                        errorMessage = 'length_error'.trParams({
                                          'field_name': '4',
                                        }).tr;
                                        return "";
                                      }
                                      return null;
                                    },
                                  );
                                },
                              ),
                              StatefulBuilder(
                                builder: (BuildContext statefulBuilderContext,
                                    setState) {
                                  return ContainerTextField(
                                    controller: confirmPinCodeController,
                                    width: context.screenWidth,
                                    height: context.setHeight(51.28),
                                    isAddOrEdit: true,
                                    borderColor: const Color(0xFFC2C3CB),
                                    fillColor: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? const Color(0xFF2B2B2B)
                                        : Colors.white.withValues(alpha: 0.43),
                                    hintcolor: const Color(0xFFC2C3CB),
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? AppColor.white
                                        : AppColor.black,
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
                                    hintText: 'confirm_pin_code'.tr,
                                    labelText: 'confirm_pin_code'.tr,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
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
                                          'field_name': 'confirm_pin_code'.tr,
                                        });
                                        countErrors++;
                                        return "";
                                      } else if (value !=
                                          pinCodeController.text) {
                                        errorMessage = 'un_match_pin'.tr;
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
                                      text: 'activate'.tr,
                                      height: context.setHeight(35),
                                      borderRadius: context.setMinSize(5),
                                      backgroundColor: AppColor.cyanTeal,
                                      showBoxShadow: true,
                                      textStyle: AppStyle.textStyle(
                                        color: Colors.white,
                                        fontSize: context.setSp(14.42),
                                        fontWeight: FontWeight.normal,
                                      ),
                                      onPressed: onPressed,
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
                                        fontSize: context.setSp(14.42),
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
          );
        },
      ),
    ),
  );
}
