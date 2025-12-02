// import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:shared_widgets/config/app_colors.dart';
// import 'package:shared_widgets/config/app_styles.dart';
// import 'package:shared_widgets/shared_widgets/app_button.dart';
// import 'package:shared_widgets/shared_widgets/app_dialog.dart';
// import 'package:shared_widgets/shared_widgets/app_loading.dart';
// import 'package:shared_widgets/shared_widgets/app_text_field.dart';
// import 'package:shared_widgets/utils/validator_helper.dart';
// import 'package:yousentech_authentication/authentication/utils/login_helper.dart';
// import '../../../authentication/domain/authentication_viewmodel.dart';

// TextEditingController passwordController = TextEditingController();
// TextEditingController confirmPasswordController = TextEditingController();
// AuthenticationController authenticationController = Get.put(AuthenticationController.getInstance());
// final _formKey = GlobalKey<FormState>();
// String? errorMessage;
// int countErrors = 0;
// bool flagPass = false;
// bool flagConfirm = false;

// changePasswordDialog() {
//   passwordController.clear();
//   confirmPasswordController.clear();
//   CustomDialog.getInstance().dialogcontent(
//     context: Get.context!,
//     content: Obx(() => IgnorePointer(
//         ignoring: authenticationController.loading.value,
//         child: SingleChildScrollView(
//           child: Container(
//             width: 80.w,
//             height: 350.h,
//             padding: const EdgeInsets.all(8),
//             child: Stack(
//               children: [
//                 Form(
//                   key: _formKey,
//                   child: Padding(
//                     padding: EdgeInsets.all(20.r),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text("change_password".tr,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: AppColor.black,
//                                 fontSize: 10.r,
//                                 fontWeight: FontWeight.bold)),
//                         Icon(
//                           Icons.password_rounded,
//                           color: AppColor.amberLight,
//                           size: Get.width * 0.06,
//                         ),
//                         SizedBox(
//                           height: 5.r,
//                         ),
//                         Text("enter_your_new_password".tr,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: AppColor.black,
//                                 fontSize: 9.r,
//                                 fontWeight: FontWeight.bold)),
//                         SizedBox(
//                           height: 10.r,
//                         ),
//                         StatefulBuilder(
//                             builder: (BuildContext context, setState) {
//                           return ContainerTextField(
//                             controller: passwordController,
//                             width: 100.w,
//                             height: 40.h,
//                             borderColor: AppColor.silverGray,
//                             iconcolor: AppColor.silverGray,
//                             hintcolor: AppColor.silverGray,
//                             isAddOrEdit: true,
//                             borderRadius: 5.r,
//                             fontSize: 10.r,
//                             prefixIcon: Padding(
//                               padding: EdgeInsets.all(8.0.r),
//                               child: SvgPicture.asset(
//                                 'assets/image/lock_on.svg',
//                                 package: 'yousentech_authentication',
//                                 fit: BoxFit
//                                     .scaleDown, // Adjust this to control scaling
//                               ),
//                             ),
//                             hintText: 'password'.tr,
//                             labelText: 'password'.tr,
//                             suffixIcon: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 10.0, right: 10),
//                               child: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       flagPass = !flagPass;
//                                     });
//                                   },
//                                   icon: flagPass
//                                       ? SvgPicture.asset(
//                                           'assets/image/eye-open.svg',
//                                           fit: BoxFit.scaleDown,
//                                           package: 'yousentech_authentication',
//                                           color: AppColor.silverGray,
//                                           // Adjust this to control scaling
//                                         )
//                                       : SvgPicture.asset(
//                                           'assets/image/eye-closed.svg',
//                                           package: 'yousentech_authentication',
//                                           fit: BoxFit
//                                               .scaleDown, // Adjust this to control scaling
//                                         )),
//                             ),
//                             obscureText: flagPass ? false : true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 errorMessage = 'required_message_f'
//                                     .trParams({'field_name': 'password'.tr});
//                                 countErrors++;
//                                 return "";
//                               } else if (value.isNotEmpty) {
//                                 var message =
//                                     ValidatorHelper.passWordValidation(
//                                         value: value);
//                                 if (message == "") {
//                                   return null;
//                                 }
//                                 errorMessage = message;
//                                 return "";
//                               }
//                               return null;
//                             },
//                           );
//                         }),

//                         SizedBox(
//                           height: 5.r,
//                         ),
//                         StatefulBuilder(
//                             builder: (BuildContext context, setState) {
//                           return ContainerTextField(
//                             controller: confirmPasswordController,
//                             width: 100.w,
//                             height: 40.h,
//                             borderColor: AppColor.silverGray,
//                             iconcolor: AppColor.silverGray,
//                             hintcolor: AppColor.silverGray,
//                             isAddOrEdit: true,
//                             borderRadius: 5.r,
//                             fontSize: 10.r,
//                             prefixIcon: Padding(
//                               padding: EdgeInsets.all(8.0.r),
//                               child: SvgPicture.asset(
//                                 'assets/image/lock_on.svg',
//                                 package: 'yousentech_authentication',
//                                 fit: BoxFit
//                                     .scaleDown, // Adjust this to control scaling
//                               ),
//                             ),
//                             hintText: 'confirm_password'.tr,
//                             labelText: 'confirm_password'.tr,
//                             suffixIcon: Padding(
//                               padding:
//                                   const EdgeInsets.only(left: 10.0, right: 10),
//                               child: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       flagConfirm = !flagConfirm;
//                                     });
//                                   },
//                                   icon: flagConfirm
//                                       ? SvgPicture.asset(
//                                           'assets/image/eye-open.svg',
//                                           fit: BoxFit.scaleDown,
//                                           package: 'yousentech_authentication',
//                                           color: AppColor.silverGray,
//                                           // Adjust this to control scaling
//                                         )
//                                       : SvgPicture.asset(
//                                           'assets/image/eye-closed.svg',
//                                           package: 'yousentech_authentication',
//                                           fit: BoxFit
//                                               .scaleDown, // Adjust this to control scaling
//                                         )),
//                             ),
//                             obscureText: flagConfirm ? false : true,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 errorMessage = 'required_message_f'.trParams(
//                                     {'field_name': 'confirm_password'.tr});
//                                 countErrors++;
//                                 return "";
//                               } else if (value != passwordController.text) {
//                                 errorMessage = 'un_match_password'.tr;
//                                 return "";
//                               } else if (value.isNotEmpty) {
//                                 var message =
//                                     ValidatorHelper.passWordValidation(
//                                         value: value);
//                                 if (message == "") {
//                                   return null;
//                                 }
//                                 errorMessage = message;
//                                 return "";
//                               }
//                               return null;
//                             },
//                           );
//                         }),
//                         SizedBox(
//                           height: 10.r,
//                         ),
//                         Column(
//                           children: [
//                             ButtonElevated(
//                                 text: "change_password".tr,
//                                 // width: Get.width / 7,
//                                 width: 100.w,
//                                 height: 30.h,
//                                 borderRadius: 9,
//                                 backgroundColor: AppColor.cyanTeal,
//                                 showBoxShadow: true,
//                                 textStyle: AppStyle.textStyle(
//                                     color: Colors.white,
//                                     fontSize: 10.r,
//                                     fontWeight: FontWeight.normal),
//                                 onPressed: () async {
//                                   countErrors = 0;
//                                   LoginHelper.changePassword(authenticationController: authenticationController, formKey: _formKey, errorMessage: errorMessage, countErrors: countErrors);
//                                 }),
//                             SizedBox(
//                               height: 10.r,
//                             ),
//                             ButtonElevated(
//                                 text: 'cancel'.tr,
//                                 width: 100.w,
//                                 height: 30.h,
//                                 borderRadius: 9,
//                                 borderColor: AppColor.paleAqua,
//                                 textStyle: AppStyle.textStyle(
//                                     color: AppColor.slateGray,
//                                     fontSize: 10.r,
//                                     fontWeight: FontWeight.normal),
//                                 onPressed: () async {
//                                   Get.back();
//                                 }),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 authenticationController.loading.value
//                     ? const LoadingWidget()
//                     : Container(),
//               ],
//             ),
//           ),
//         ))),
//   );
// }
