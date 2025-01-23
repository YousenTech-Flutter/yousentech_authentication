import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:remote_database_setting/remote_database_setting/domain/remote_database_setting_service.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/config/app_colors.dart';

TextEditingController database = TextEditingController();
TextEditingController url = TextEditingController();
TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();

final _formKey = GlobalKey<FormState>();
String? errorMessage;
int countErrors = 0;
bool flag = false;

simulateConnectionDialog() {
  CustomDialog.getInstance().dialog(
    icon: Icons.info,
    title: 'main_connection_info'.tr,
    content: Center(
      child: Container(
        // width: Get.width * 0.4,
        width: 100.w,
        // height: Get.height * 0.5,
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ContainerTextField(
                width: 100.w,
                height: 40.h,
                borderColor: AppColor.silverGray,
                iconcolor: AppColor.silverGray,
                hintcolor: AppColor.silverGray,
                isAddOrEdit: true,
                borderRadius: 5.r,
                controller: database,
                // prefixIcon: Icon(
                //   Icons.key,
                //   size: 4.sp,
                //   color: AppColor.black,
                // ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: SvgPicture.asset(
                    'assets/image/user-1.svg',
                    fit: BoxFit.scaleDown,
                    color: AppColor.silverGray,
                    package: 'yousentech_authentication',
                  ),
                ),
                hintText: 'database'.tr,
                labelText: 'database'.tr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    errorMessage = 'required_message_f'
                        .trParams({'field_name': 'database'.tr});
                    countErrors++;
                    return "";
                  }
                  return null;
                },
              ),
              ContainerTextField(
                width: 100.w,
                height: 40.h,
                borderColor: AppColor.silverGray,
                iconcolor: AppColor.silverGray,
                hintcolor: AppColor.silverGray,
                isAddOrEdit: true,
                borderRadius: 5.r,
                controller: url,
                // prefixIcon: Icon(
                //   Icons.key,
                //   size: 4.sp,
                //   color: AppColor.black,
                // ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: SvgPicture.asset(
                    'assets/image/user-1.svg',
                    fit: BoxFit.scaleDown,
                    color: AppColor.silverGray,
                    package: 'yousentech_authentication',
                  ),
                ),
                hintText: 'url'.tr,
                labelText: 'url'.tr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    errorMessage =
                        'required_message'.trParams({'field_name': 'url'.tr});
                    countErrors++;
                    return "";
                  }
                  return null;
                },
              ),
              ContainerTextField(
                width: 100.w,
                height: 40.h,
                borderColor: AppColor.silverGray,
                iconcolor: AppColor.silverGray,
                hintcolor: AppColor.silverGray,
                isAddOrEdit: true,
                borderRadius: 5.r,
                controller: username,
                // prefixIcon: Icon(
                //   Icons.key,
                //   size: 4.sp,
                //   color: AppColor.black,
                // ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.0.r),
                  child: SvgPicture.asset(
                    'assets/image/user-1.svg',
                    fit: BoxFit.scaleDown,
                    color: AppColor.silverGray,
                    package: 'yousentech_authentication',
                  ),
                ),
                hintText: 'username'.tr,
                labelText: 'username'.tr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    errorMessage = 'required_message'
                        .trParams({'field_name': 'username'.tr});
                    countErrors++;
                    return "";
                  }
                  return null;
                },
              ),
              StatefulBuilder(builder: (BuildContext context, setState) {
                return ContainerTextField(
                  width: 100.w,
                  height: 40.h,
                  borderColor: AppColor.silverGray,
                  iconcolor: AppColor.silverGray,
                  hintcolor: AppColor.silverGray,
                  isAddOrEdit: true,
                  borderRadius: 5.r,
                  controller: password,
                  // prefixIcon: Icon(
                  //   Icons.key,
                  //   size: 4.sp,
                  //   color: AppColor.black,
                  // ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: SvgPicture.asset(
                      'assets/image/user-1.svg',
                      fit: BoxFit.scaleDown,
                      color: AppColor.silverGray,
                      package: 'yousentech_authentication',
                    ),
                  ),
                  hintText: 'password'.tr,
                  labelText: 'password'.tr,
                  // suffixIcon: Padding(
                  //   padding: const EdgeInsets.only(left: 10.0, right: 10),
                  //   child: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           flag = !flag;
                  //         });
                  //       },
                  //       icon: flag
                  //           ? Icon(
                  //               Icons.visibility,
                  //               color: AppColor.black,
                  //             )
                  //           : Icon(
                  //               Icons.visibility_off,
                  //               color: AppColor.black,
                  //             )),
                  // ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                        icon: flag
                            ? SvgPicture.asset(
                                'assets/image/eye-open.svg',
                                fit: BoxFit.scaleDown,
                                color: AppColor.silverGray,
                                package: 'yousentech_authentication',
                                // Adjust this to control scaling
                              )
                            : SvgPicture.asset(
                                'assets/image/eye-closed.svg',
                                package: 'yousentech_authentication',
                                fit: BoxFit
                                    .scaleDown, // Adjust this to control scaling
                              )),
                  ),
                  obscureText: flag ? false : true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      errorMessage = 'required_message'
                          .trParams({'field_name': 'password'.tr});
                      countErrors++;
                      return "";
                    }
                    return null;
                  },
                );
              }),
            ],
          ),
        ),
      ),
    ),
    primaryButtonText: 'save'.tr,
    onPressed: () async {
      countErrors = 0;
      if (_formKey.currentState!.validate()) {
        await RemoteDatabaseSettingService.instantiateOdooConnection(
                url: url.text,
                db: database.text,
                username: username.text,
                password: password.text)
            .then((value) async {
          if (value is bool && value == true) {
            // to save the login info
            // await SharedPr.setLoginObj(loginObj: LoginInfo(db:database.text , url: url.text, password: password.text, userName: username.text));
            Get.back();
            appSnackBar(
                message: 'success'.tr, messageType: MessageTypes.success);
          } else {
            appSnackBar(
              message: value,
            );
          }
        });
      } else {
        // if (kDebugMode) {
        //   // print(countErrors);
        // }
        appSnackBar(
          message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
        );
      }
    },
    message: ''.tr,
  );
}
