import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
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
    content: Obx(
      () => IgnorePointer(
        ignoring: authenticationController.loading.value,
        child: SingleChildScrollView(
          child: Container(
            width: context.setWidth(80),
            height: context.setHeight(350),
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(context.setMinSize(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "change_password".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: context.setSp(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.password_rounded,
                          color: AppColor.amberLight,
                          size: Get.width * 0.06,
                        ),
                        SizedBox(height: context.setHeight(10)),
                        Text(
                          "enter_your_new_password".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: context.setSp(10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: context.setHeight(10)),
                        StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return ContainerTextField(
                              controller: passwordController,
                              width: context.setWidth(100),
                              height: context.setHeight(40),
                              borderColor: AppColor.silverGray,
                              iconcolor: AppColor.silverGray,
                              hintcolor: AppColor.silverGray,
                              isAddOrEdit: true,
                              borderRadius: context.setMinSize(5),
                              fontSize: context.setSp(10),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(context.setMinSize(8)),
                                child: SvgPicture.asset(
                                  AppImages.lockOn,
                                  
                                  package: 'shared_widgets',
                                  fit:
                                      BoxFit
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
                                  icon:
                                      flagPass
                                          ? SvgPicture.asset(
                                            AppImages.eyeOpen,
                                           
                                            fit: BoxFit.scaleDown,
                                            package: 'shared_widgets',
                                            color: AppColor.silverGray,
                                            // Adjust this to control scaling
                                          )
                                          : SvgPicture.asset(
                                            AppImages.eyeClosed,
                                            package: 'shared_widgets',
                                            fit:
                                                BoxFit
                                                    .scaleDown, // Adjust this to control scaling
                                          ),
                                ),
                              ),
                              obscureText: flagPass ? false : true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  errorMessage = 'required_message_f'.trParams({
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
                              width: context.setWidth(100),
                              height: context.setHeight(40),
                              borderColor: AppColor.silverGray,
                              iconcolor: AppColor.silverGray,
                              hintcolor: AppColor.silverGray,
                              isAddOrEdit: true,
                              borderRadius: context.setMinSize(5),
                              fontSize: context.setSp(10),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(context.setMinSize(8)),
                                child: SvgPicture.asset(
                                  AppImages.lockOn,
                                  package: 'shared_widgets',
                                  fit:
                                      BoxFit
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
                                  icon:
                                      flagConfirm
                                          ? SvgPicture.asset(
                                            AppImages.eyeOpen,
                                            
                                            fit: BoxFit.scaleDown,
                                            package: 'shared_widgets',
                                            color: AppColor.silverGray,
                                            // Adjust this to control scaling
                                          )
                                          : SvgPicture.asset(
                                            AppImages.eyeClosed,
                                            package: 'shared_widgets',
                                            fit:
                                                BoxFit
                                                    .scaleDown, // Adjust this to control scaling
                                          ),
                                ),
                              ),
                              obscureText: flagConfirm ? false : true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  errorMessage = 'required_message_f'.trParams({
                                    'field_name': 'confirm_password'.tr,
                                  });
                                  countErrors++;
                                  return "";
                                } else if (value != passwordController.text) {
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
                        SizedBox(height: context.setHeight(10)),
                        Column(
                          children: [
                            ButtonElevated(
                              text: "change_password".tr,
                              width: context.setWidth(100),
                              height: context.setHeight(30),
                              borderRadius: 9,
                              backgroundColor: AppColor.cyanTeal,
                              showBoxShadow: true,
                              textStyle: AppStyle.textStyle(
                                color: Colors.white,
                                fontSize: context.setSp(10),
                                fontWeight: FontWeight.normal,
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  appSnackBar(
                                    message:
                                        countErrors > 1
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
                                  password: passwordController.text
                                );
                              },
                            ),
                            SizedBox(height: context.setHeight(10)),
                            ButtonElevated(
                              text: 'cancel'.tr,
                              width: context.setWidth(100),
                              height: context.setHeight(30),
                              borderRadius: 9,
                              borderColor: AppColor.paleAqua,
                              textStyle: AppStyle.textStyle(
                                color: AppColor.slateGray,
                                fontSize: context.setSp(10),
                                fontWeight: FontWeight.normal,
                              ),
                              onPressed: () async {
                                Get.back();
                              },
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
}
