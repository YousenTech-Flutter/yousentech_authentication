// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_enums.dart';
import '../../../authentication/domain/authentication_viewmodel.dart';
import '../../../authentication/presentation/views/login_screen.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/response_result.dart';

TextEditingController pinCodeController = TextEditingController();
TextEditingController confirmPinCodeController = TextEditingController();
AuthenticationController authenticationController =
    Get.put(AuthenticationController.getInstance());

activatePINLogin({bool enable = true}) async {
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

  // CustomDialog.getInstance().dialog(
  //   title: 'enable_pin_login',
  //   buttonheight: 0.04.sh,
  //   contentPadding: 20.r,
  //   content: Center(
  //     child: Container(
  //       width: 80.w,
  //       padding: EdgeInsets.all(5.r),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             StatefulBuilder(builder: (BuildContext context, setState) {
  //               return ContainerTextField(
  //                 controller: pinCodeController,
  //                 width: 100.w,
  //                 height: 40.h,
  //                 borderColor: AppColor.silverGray,
  //                 iconcolor: AppColor.silverGray,
  //                 hintcolor: AppColor.silverGray,
  //                 isAddOrEdit: true,
  //                 borderRadius: 5.r,
  //                 fontSize: 9.r,
  //                 prefixIcon: Padding(
  //                   padding: EdgeInsets.all(8.0.r),
  //                   child: SvgPicture.asset(
  //                     'assets/image/lock_on.svg',
  //                     fit: BoxFit.scaleDown, // Adjust this to control scaling
  //                   ),
  //                 ),
  //                 hintText: 'pin_code'.tr,
  //                 labelText: 'pin_code'.tr,
  //                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //                 suffixIcon: Padding(
  //                   padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                   child: IconButton(
  //                       onPressed: () {
  //                         setState(() {
  //                           flagPin = !flagPin;
  //                         });
  //                       },
  //                       icon: flagPin
  //                           ? SvgPicture.asset(
  //                               'assets/image/eye-open.svg',
  //                               fit: BoxFit.scaleDown,
  //                               color: AppColor.silverGray,
  //                               // Adjust this to control scaling
  //                             )
  //                           : SvgPicture.asset(
  //                               'assets/image/eye-closed.svg',
  //                               fit: BoxFit
  //                                   .scaleDown, // Adjust this to control scaling
  //                             )),
  //                 ),
  //                 obscureText: flagPin ? false : true,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     errorMessage = 'required_message'
  //                         .trParams({'field_name': 'pin_code'.tr});
  //                     countErrors++;
  //                     return "";
  //                   } else if (value.length < 4) {
  //                     errorMessage =
  //                         'length_error'.trParams({'field_name': '4'}).tr;
  //                     return "";
  //                   }
  //                   return null;
  //                 },
  //               );
  //             }),
  //             SizedBox(
  //               height: 10.r,
  //             ),
  //             StatefulBuilder(builder: (BuildContext context, setState) {
  //               return ContainerTextField(
  //                 controller: confirmPinCodeController,
  //                 width: 100.w,
  //                 height: 40.h,
  //                 isAddOrEdit: true,
  //                 borderColor: AppColor.silverGray,
  //                 iconcolor: AppColor.silverGray,
  //                 hintcolor: AppColor.silverGray,
  //                 borderRadius: 5.r,
  //                 fontSize: 9.r,
  //                 prefixIcon: Padding(
  //                   padding: EdgeInsets.all(8.0.r),
  //                   child: SvgPicture.asset(
  //                     'assets/image/lock_on.svg',
  //                     fit: BoxFit.scaleDown, // Adjust this to control scaling
  //                   ),
  //                 ),
  //                 hintText: 'confirm_pin_code'.tr,
  //                 labelText: 'confirm_pin_code'.tr,
  //                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],

  //                 suffixIcon: Padding(
  //                   padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                   child: IconButton(
  //                       onPressed: () {
  //                         setState(() {
  //                           flagConfirm = !flagConfirm;
  //                         });
  //                       },
  //                       icon: flagConfirm
  //                           ? SvgPicture.asset(
  //                               'assets/image/eye-open.svg',
  //                               fit: BoxFit.scaleDown,
  //                               color: AppColor.silverGray,
  //                               // Adjust this to control scaling
  //                             )
  //                           : SvgPicture.asset(
  //                               'assets/image/eye-closed.svg',
  //                               fit: BoxFit
  //                                   .scaleDown, // Adjust this to control scaling
  //                             )),
  //                 ),
  //                 obscureText: flagConfirm ? false : true,
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     errorMessage = 'required_message_f'
  //                         .trParams({'field_name': 'confirm_pin_code'.tr});
  //                     countErrors++;
  //                     return "";
  //                   } else if (value != pinCodeController.text) {
  //                     errorMessage = 'un_match_pin'.tr;
  //                     return "";
  //                   }
  //                   return null;
  //                 },
  //               );
  //             }),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  //   primaryButtonText: 'activate'.tr,
  //   buttonwidth: 77.w,
  //   fontSizetext: 9.r,
  //   fontSizetital: 10.r,
  //   onPressed: () async {
  //     countErrors = 0;
  //     if (_formKey.currentState!.validate()) {
  //       ResponseResult responseResult = await authenticationController.activatePinLogin(pinCode: pinCodeController.text);
  //       await SharedPr.updatePinCodeValue(pinCode: pinCodeController.text);
  //       if (responseResult.status) {
  //         Get.offAll(() => const LoginScreen());
  //         await SharedPr.removeUserObj();
  //       }
  //       appSnackBar(
  //         messageType: MessageTypes.success,
  //         message: responseResult.message,
  //       );
  //     } else {
  //       appSnackBar(
  //         message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
  //       );
  //     }
  //   },
  //   message: 'enter_pin_code'.tr,
  //   icon: Icons.pin,
  // )

  CustomDialog.getInstance().dialogcontent(
    context: Get.context!,
    content: KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          onPressed();
        }
      },
      child: Obx(() => IgnorePointer(
          ignoring: authenticationController.loading.value,
          child: SingleChildScrollView(
            child: SizedBox(
              width: 80.w,
              height: 320.h,
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('enable_pin_login'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: 10.r,
                                  fontWeight: FontWeight.bold)),
                          Icon(
                            Icons.pin,
                            color: AppColor.amberLight,
                            size: Get.width * 0.06,
                          ),
                          SizedBox(
                            height: 5.r,
                          ),
                          Text('enter_pin_code'.tr,
                              textAlign: TextAlign.center,
                              style: AppStyle.textStyle(
                                  fontSize: 9.r,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.lavenderGray)),
                          SizedBox(
                            height: 10.r,
                          ),
                          StatefulBuilder(
                              builder: (BuildContext context, setState) {
                            return ContainerTextField(
                              controller: pinCodeController,
                              width: 100.w,
                              height: 40.h,
                              borderColor: AppColor.silverGray,
                              iconcolor: AppColor.silverGray,
                              hintcolor: AppColor.silverGray,
                              isAddOrEdit: true,
                              borderRadius: 5.r,
                              fontSize: 9.r,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: SvgPicture.asset(
                                  'assets/image/lock_on.svg',
                                  fit: BoxFit
                                      .scaleDown, // Adjust this to control scaling
                                ),
                              ),
                              hintText: 'pin_code'.tr,
                              labelText: 'pin_code'.tr,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        flagPin = !flagPin;
                                      });
                                    },
                                    icon: flagPin
                                        ? SvgPicture.asset(
                                            'assets/image/eye-open.svg',
                                            fit: BoxFit.scaleDown,
                                            color: AppColor.silverGray,
                                            // Adjust this to control scaling
                                          )
                                        : SvgPicture.asset(
                                            'assets/image/eye-closed.svg',
                                            fit: BoxFit
                                                .scaleDown, // Adjust this to control scaling
                                          )),
                              ),
                              obscureText: flagPin ? false : true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  errorMessage = 'required_message'
                                      .trParams({'field_name': 'pin_code'.tr});
                                  countErrors++;
                                  return "";
                                } else if (value.length < 4) {
                                  errorMessage = 'length_error'
                                      .trParams({'field_name': '4'}).tr;
                                  return "";
                                }
                                return null;
                              },
                            );
                          }),
                          // SizedBox(
                          //   height: 10.r,
                          // ),
                          SizedBox(
                            height: 5.r,
                          ),
                          StatefulBuilder(
                              builder: (BuildContext context, setState) {
                            return ContainerTextField(
                              controller: confirmPinCodeController,
                              width: 100.w,
                              height: 40.h,
                              isAddOrEdit: true,
                              borderColor: AppColor.silverGray,
                              iconcolor: AppColor.silverGray,
                              hintcolor: AppColor.silverGray,
                              borderRadius: 5.r,
                              fontSize: 9.r,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(8.0.r),
                                child: SvgPicture.asset(
                                  'assets/image/lock_on.svg',
                                  fit: BoxFit
                                      .scaleDown, // Adjust this to control scaling
                                ),
                              ),
                              hintText: 'confirm_pin_code'.tr,
                              labelText: 'confirm_pin_code'.tr,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        flagConfirm = !flagConfirm;
                                      });
                                    },
                                    icon: flagConfirm
                                        ? SvgPicture.asset(
                                            'assets/image/eye-open.svg',
                                            fit: BoxFit.scaleDown,
                                            color: AppColor.silverGray,
                                            // Adjust this to control scaling
                                          )
                                        : SvgPicture.asset(
                                            'assets/image/eye-closed.svg',
                                            fit: BoxFit
                                                .scaleDown, // Adjust this to control scaling
                                          )),
                              ),
                              obscureText: flagConfirm ? false : true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  errorMessage = 'required_message_f'.trParams(
                                      {'field_name': 'confirm_pin_code'.tr});
                                  countErrors++;
                                  return "";
                                } else if (value != pinCodeController.text) {
                                  errorMessage = 'un_match_pin'.tr;
                                  return "";
                                }
                                return null;
                              },
                            );
                          }),
                          SizedBox(
                            height: 10.r,
                          ),
                          Column(
                            children: [
                              ButtonElevated(
                                text: 'activate'.tr,
                                height: 30.h,
                                width: 100.w,
                                borderRadius: 9,
                                backgroundColor: AppColor.cyanTeal,
                                showBoxShadow: true,
                                textStyle: AppStyle.textStyle(
                                    color: Colors.white,
                                    fontSize: 3.sp,
                                    fontWeight: FontWeight.normal),
                                onPressed: onPressed,
                              ),
                              SizedBox(
                                height: 10.r,
                              ),
                              ButtonElevated(
                                  text: 'cancel'.tr,
                                  width: 100.w,
                                  height: 30.h,
                                  borderRadius: 9,
                                  borderColor: AppColor.paleAqua,
                                  textStyle: AppStyle.textStyle(
                                      color: AppColor.slateGray,
                                      fontSize: 3.sp,
                                      fontWeight: FontWeight.normal),
                                  onPressed: () async {
                                    Get.back();
                                  }),
                            ],
                          )
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
          ))),
    ),
  );
}
