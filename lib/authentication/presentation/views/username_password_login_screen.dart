import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/models/authentication_data/login_info.dart';
import 'package:pos_shared_preferences/models/notification_helper_model.dart';
import 'package:remote_database_setting/remote_database_setting/domain/remote_database_setting_viewmodel.dart';
import 'package:remote_database_setting/remote_database_setting/presentation/create_support_ticket.dart';
import 'package:shared_widgets/config/app_enum.dart';
import 'package:shared_widgets/config/app_lists.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_authentication/authentication/presentation/widgets/change_password_screen.dart';
import 'package:yousentech_pos_dashboard/dashboard/src/presentation/views/home_page.dart';
import '../../domain/authentication_viewmodel.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_close_dialog.dart';
import 'package:shared_widgets/shared_widgets/card_login.dart';

class UsernameAndPasswordLoginScreen extends StatefulWidget {
  const UsernameAndPasswordLoginScreen({super.key});

  @override
  State<UsernameAndPasswordLoginScreen> createState() =>
      _UsernameAndPasswordLoginScreenState();
}

class _UsernameAndPasswordLoginScreenState
    extends State<UsernameAndPasswordLoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthenticationController authenticationController =
      Get.put(AuthenticationController.getInstance());
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  int countErrors = 0;
  bool flag = false;
  final _buttonFocusNode = FocusNode();
  var userNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    userNameFocusNode.requestFocus();
    flutterWindowCloseshow(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => IgnorePointer(
          ignoring: authenticationController.loading.value,
          child: Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
            },
            child: Actions(
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (ActivateIntent intent) => onPressed(),
                ),
              },
              child: SizedBox(
                width: double.infinity,
                height: 600.h,
                child: Stack(
                  children: [
                    CardLogin(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'login'.tr,
                                    style: TextStyle(
                                        fontSize: 12.r,
                                        color: AppColor.charcoal,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'hi'.tr,
                                          style: TextStyle(
                                              fontSize: 9.r,
                                              color: AppColor.lavenderGray,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Tajawal'),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${SharedPr.chosenUserObj!.name}  ',
                                          style: TextStyle(
                                              fontSize: 9.r,
                                              color: AppColor.cyanTeal,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Tajawal'),
                                        ),
                                        TextSpan(
                                          text:
                                              'enter_username_and_password'.tr,
                                          style: TextStyle(
                                              fontSize: 9.r,
                                              color: AppColor.lavenderGray,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Tajawal'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.02.sh,
                                ),
                                // Text(
                                //   'username'.tr,
                                //   style: TextStyle(
                                //       fontSize: 7.r,
                                //       color: AppColor.charcoal,
                                //       fontWeight: FontWeight.w400),
                                // ),
                                ContainerTextField(
                                  width: ScreenUtil().screenWidth,
                                  height: 30.h,
                                  controller: usernameController,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(8.0.r),
                                    child: SvgPicture.asset(
                                      'assets/image/user-1.svg',
                                      fit: BoxFit.scaleDown,
                                      package: 'yousentech_authentication',
                                      color: AppColor.silverGray,
                                    ),
                                  ),
                                  iconcolor: AppColor.silverGray,
                                  focusNode: userNameFocusNode,
                                  borderRadius: 5.r,
                                  fontSize: 9.r,
                                  showLable: true,
                                  labelText: 'username'.tr,
                                  isAddOrEdit: true,
                                  hintcolor: AppColor.silverGray,
                                  borderColor: AppColor.silverGray,
                                  hintText: 'username'.tr,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      errorMessage = 'required_message'
                                          .trParams(
                                              {'field_name': 'username'.tr});
                                      countErrors++;
                                      return "";
                                    }
                                    if (value !=
                                        SharedPr.chosenUserObj!.userName) {
                                      errorMessage = 'user_does_not_match'
                                          .trParams(
                                              {'field_name': 'username'.tr});
                                      countErrors++;
                                      return "";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                // Text(
                                //   SharedPr.isForgetPass!
                                //       ? 'otp_password'.tr
                                //       : 'password'.tr,
                                //   style: TextStyle(
                                //       fontSize: 7.r,
                                //       color: AppColor.charcoal,
                                //       fontWeight: FontWeight.w400),
                                // ),
                                GetBuilder<AuthenticationController>(
                                    builder: (context) {
                                  return ContainerTextField(
                                    showLable: true,
                                    labelText: SharedPr.isForgetPass!
                                        ? 'otp_password'.tr
                                        : 'password'.tr,
                                    width: ScreenUtil().screenWidth,
                                    height: 30.h,
                                    controller: passwordController,

                                    iconcolor: AppColor.silverGray,
                                    isAddOrEdit: true,
                                    borderRadius: 5.r,
                                    fontSize: 9.r,
                                    hintcolor: AppColor.silverGray,
                                    borderColor: AppColor.silverGray,
                                    hintText: SharedPr.isForgetPass!
                                        ? 'otp_password'.tr
                                        : 'password'.tr,
                                    // labelText: 'key_number'.tr,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(8.0.r),
                                      child: SvgPicture.asset(
                                        'assets/image/lock_on.svg',
                                        package: 'yousentech_authentication',
                                        fit: BoxFit
                                            .scaleDown, // Adjust this to control scaling
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10),
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
                                                  package:
                                                      'yousentech_authentication',
                                                  color: AppColor.silverGray,
                                                  // Adjust this to control scaling
                                                )
                                              : SvgPicture.asset(
                                                  'assets/image/eye-closed.svg',
                                                  package:
                                                      'yousentech_authentication',
                                                  fit: BoxFit
                                                      .scaleDown, // Adjust this to control scaling
                                                )),
                                    ),
                                    obscureText: flag ? false : true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        errorMessage = 'required_message_f'
                                            .trParams({
                                          'field_name': SharedPr.isForgetPass!
                                              ? 'otp_password'.tr
                                              : 'password'.tr
                                        });
                                        return "";
                                      }
                                      // if (value.isNotEmpty) {
                                      //   var message = ValidatorHelper.passWordValidation(value: value);
                                      //   if (message == "") {
                                      //     return null;
                                      //   }
                                      //   errorMessage = message;
                                      //   return "";
                                      // }
                                      return null;
                                    },
                                  );
                                }),
                                SizedBox(
                                  height: 0.01.sh,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (SharedPr.chosenUserObj!.pinCodeLock! <
                                        3)
                                      GetBuilder<AuthenticationController>(
                                          id: "choosePin",
                                          builder: (context) {
                                            return TextButton(
                                                onPressed: () async {
                                                  authenticationController
                                                      .setChoosePin();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/image/login_icon.svg',
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        package:
                                                            'yousentech_authentication',
                                                        fit: BoxFit.fill,
                                                        width: 10.r,
                                                        height: 10.r,
                                                      ),
                                                      // FaIcon(
                                                      //   FontAwesomeIcons
                                                      //       .arrowRightFromBracket,
                                                      //   color: AppColor.amber,
                                                      //   size: 3.sp,
                                                      // ),
                                                      SizedBox(
                                                        width: 7.r,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          !authenticationController
                                                                  .choosePin
                                                              ? "switch_to_pin_login"
                                                                  .tr
                                                              : "switch_to_username_login"
                                                                  .tr,
                                                          style: TextStyle(
                                                              fontSize: 9.r,
                                                              color: AppColor
                                                                  .charcoal,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ));
                                          }),
                                    TextButton(
                                        onPressed: () async {
                                          // CustomDialog.getInstance().dialog2(
                                          //   title: "confirm_reset_password".tr,
                                          //   dialogType: MessageTypes.warning,
                                          //   primaryButtonText:"confirm_reset_password".tr,
                                          //   onPressed: () async {
                                          //     ResponseResult responseResult =await authenticationController.forgetPassword();
                                          //     if (responseResult.status) {
                                          //       Get.back();
                                          //       appSnackBar(
                                          //           message:
                                          //               responseResult.message,
                                          //           messageType:
                                          //               MessageTypes.success);
                                          //     } else {
                                          //       Get.back();

                                          //       showPassWordErrorDialog(
                                          //           message:
                                          //               responseResult.message);
                                          //     }
                                          //   },
                                          //   context: context,
                                          // );
                                          CustomDialog.getInstance()
                                              .dialogcontent(
                                            barrierDismissible: true,
                                            content: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          color: messageTypesIcon2[
                                                                  MessageTypes
                                                                      .warning]!
                                                              .last as Color,
                                                          width: 10.r)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r)),
                                              padding: EdgeInsets.all(10.0.r),
                                              height: 0.3.sh,
                                              width: 0.3.sw,
                                              child: Obx(() => IgnorePointer(
                                                  ignoring:
                                                      authenticationController
                                                          .loading.value,
                                                  child: Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                if (messageTypesIcon2[
                                                                            MessageTypes.warning]!
                                                                        .first !=
                                                                    "") ...[
                                                                  SizedBox(
                                                                    height:
                                                                        20.r,
                                                                  ),
                                                                  SvgPicture
                                                                      .asset(
                                                                    messageTypesIcon2[MessageTypes.warning]!
                                                                            .first
                                                                        as String,
                                                                    clipBehavior:
                                                                        Clip.antiAlias,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    width: 50.r,
                                                                    height:
                                                                        50.r,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5.r,
                                                                  ),
                                                                  Text(
                                                                    "confirm_reset_password"
                                                                        .tr,
                                                                    style: AppStyle.textStyle(
                                                                        fontSize: 10
                                                                            .r,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                                SizedBox(
                                                                  height: 10.r,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              ButtonElevated(
                                                                  text:
                                                                      "confirm_reset_password"
                                                                          .tr,
                                                                  width:
                                                                      0.13.sw,
                                                                  backgroundColor:
                                                                      messageTypesIcon2[MessageTypes.warning]!
                                                                              .last
                                                                          as Color,
                                                                  textStyle: AppStyle.textStyle(
                                                                      color: AppColor
                                                                          .white,
                                                                      fontSize:
                                                                          10.r,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  onPressed:
                                                                      () async {
                                                                    ResponseResult
                                                                        responseResult =
                                                                        await authenticationController
                                                                            .forgetPassword();
                                                                    if (responseResult
                                                                        .status) {
                                                                      Get.back();
                                                                      appSnackBar(
                                                                          message: responseResult
                                                                              .message,
                                                                          messageType:
                                                                              MessageTypes.success);
                                                                    } else {
                                                                      Get.back();
                                                                      showPassWordErrorDialog(
                                                                          message:
                                                                              responseResult.message);
                                                                    }
                                                                  }),
                                                              SizedBox(
                                                                width: 10.r,
                                                              ),
                                                              ButtonElevated(
                                                                  text: 'cancel'
                                                                      .tr,
                                                                  width:
                                                                      0.13.sw,
                                                                  borderColor:
                                                                      AppColor
                                                                          .paleAqua,
                                                                  textStyle: AppStyle.textStyle(
                                                                      color: AppColor
                                                                          .slateGray,
                                                                      fontSize:
                                                                          10.r,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  onPressed:
                                                                      () async {
                                                                    Get.back();
                                                                  }),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      authenticationController
                                                              .loading.value
                                                          ? const LoadingWidget()
                                                          : Container(),
                                                    ],
                                                  ))),
                                            ),
                                            context: context,
                                          );
                                        },
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            "forget_password".tr,
                                            style: TextStyle(
                                                fontSize: 9.r,
                                                color: AppColor.cyanTeal,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),

                        // Obx(() {
                        //   if (authenticationController.loading.value) {
                        //     return CircularProgressIndicator(
                        //       color: AppColor.white,
                        //       backgroundColor: AppColor.black,
                        //     );
                        //   } else {
                        //     return

                        KeyboardListener(
                          focusNode: _buttonFocusNode,
                          autofocus: true,
                          onKeyEvent: (event) {
                            if (event.logicalKey == LogicalKeyboardKey.enter) {
                              onPressed();
                            }
                          },
                          child: Focus(
                              autofocus: true,
                              child: Builder(builder: (context) {
                                return InkWell(
                                  onTap: onPressed,
                                  child: Container(
                                    height: 30.h,
                                    width: ScreenUtil().screenWidth,
                                    alignment: Alignment.center,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5)
                                            .r,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: AppColor.aqua,
                                              blurRadius: 30,
                                              offset: const Offset(0, 4),
                                              spreadRadius: 0)
                                        ],
                                        color: AppColor.cyanTeal,
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    child: Text(
                                      'login'.tr,
                                      style: TextStyle(
                                          fontSize: 9.r,
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                );
                              })),
                        ),
                        // }
                        // }),
                      ],
                    ),
                    authenticationController.loading.value
                        ? LoadingWidget(
                            height: 600.h,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  onPressed() async {
    // if (usernameController.text != SharedPr.chosenUserObj!.userName) {

    // appSnackBar(
    //     message:
    //         'user_does_not_match'.trParams({'field_name': 'username'.tr}));
    // return;
    // }

    countErrors = 0;
    if (_formKey.currentState!.validate()) {
      // print("validate true");
      if (SharedPr.isForgetPass!) {
        // print("SharedPr.isForgetPass!");
        ResponseResult responseResult = await authenticationController
            .authenticateUsingUsernameAndPassword(LoginInfo(
                userName: usernameController.text,
                password: passwordController.text));
        if (responseResult.status && responseResult.data.accountLock < 3) {
          await authenticationController.countUsernameFailureAttempt(
              reset: true);
          responseResult.data.accountLock = 0;
          await SharedPr.setUserObj(userObj: responseResult.data);
          await SharedPr.setForgetPass(flage: false, otp: '');
          // // TODO AMAL : Change to what user choose
          // await SharedPr.setCurrentPOS(posId: 1);
          changePasswordDialog();
        } else {
          if (responseResult.message == "un_trusted_device".tr) {
            appSnackBar(
              message: responseResult.message,
            );
            return;
          } else if (responseResult.message == "no_connection".tr) {
            appSnackBar(
              message: responseResult.message,
            );
            authenticationController.loading.value = false;
            return;
          } else {
            if (SharedPr.chosenUserObj!.accountLock! < 3) {
              await SharedPr.updateAccountLockCountLocally();
              await authenticationController.countUsernameFailureAttempt();
              if (SharedPr.chosenUserObj!.accountLock! < 3) {
                appSnackBar(
                    message: 'unsuccessful_login'.trParams({
                  "field_name":
                      "${(3 - SharedPr.chosenUserObj!.accountLock!) == 0 ? 'account_locked'.tr : 3 - SharedPr.chosenUserObj!.accountLock!}"
                }));
              } else {
                showAccountLockDialog();
              }
            } else {
              showAccountLockDialog();
            }
          }
        }
      } else {
        ResponseResult responseResult = await authenticationController
            .authenticateUsingUsernameAndPassword(LoginInfo(
                userName: usernameController.text,
                password: passwordController.text));
        if (responseResult.status && responseResult.data.accountLock < 3) {
          Get.to(() => const HomePage());

          // Get.to(() => const DashboardScreen());
          appSnackBar(
            messageType: MessageTypes.success,
            message: responseResult.message,
          );
          // TODO: open commit after LocalBackup featcher
          // if (SharedPr.localBackUpSettingObj?.backupSavePth != null &&
          //     SharedPr.localBackUpSettingObj!.selectedOption ==
          //         BackUpOptions.backup_on_login.name) {
          //   await showLocalBackupPrompt();
          // }
        } else {
          if (responseResult.message == "un_trusted_device".tr) {
            appSnackBar(
              message: responseResult.message,
            );
            return;
          } else if (responseResult.message == "no_connection".tr) {
            appSnackBar(
              message: responseResult.message,
            );
            authenticationController.loading.value = false;
            return;
          } else {
            if (SharedPr.chosenUserObj!.accountLock! < 3) {
              await SharedPr.updateAccountLockCountLocally();
              await authenticationController.countUsernameFailureAttempt();
              if (SharedPr.chosenUserObj!.accountLock! < 3) {
                appSnackBar(
                    message: 'unsuccessful_login'.trParams({
                  "field_name":
                      "${(3 - SharedPr.chosenUserObj!.accountLock!) == 0 ? 'account_locked'.tr : 3 - SharedPr.chosenUserObj!.accountLock!}"
                }));
              } else {
                showAccountLockDialog();
              }
            } else {
              showAccountLockDialog();
            }
          }
        }
      }
    } else {
      // print("countErrors $countErrors");
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
    }
  }
}

void showAccountLockDialog() {
  // CustomDialog.getInstance().dialog(
  //     title: 'account_unlock_request'.tr,
  //     buttonheight: 0.04.sh,
  //     contentPadding: 20.r,
  //     buttonwidth: 77.w,
  //     fontSizetext: 9.r,
  //     fontSizetital: 10.r,
  //     message: '${'account_locked'.tr}\n${'account_unlock_request_message'.tr}',
  //     primaryButtonText: 'yes'.tr,
  //     icon: Icons.lock_person,
  //     onPressed: () async {
  //       var result =
  //           await authenticationController.sendTicketToEliminateAccountLock();
  //       if (result.status) {
  //         SharedPr.setNotificationObj(
  //             notificationHelperObj: NotificationHelper(accountLock: true));
  //         Get.back();
  //         appSnackBar(
  //             messageType: MessageTypes.success,
  //             message: 'success_send_ticket'.tr);
  //       } else {
  //         Get.back();
  //         appSnackBar(
  //             messageType: MessageTypes.error,
  //             message: 'send_ticket_already'.tr);
  //       }
  //     });
  onPressed() async {
    var result =
        await authenticationController.sendTicketToEliminateAccountLock();
    if (result.status) {
      SharedPr.setNotificationObj(
          notificationHelperObj: NotificationHelper(accountLock: true));
      Get.back();
      appSnackBar(
          messageType: MessageTypes.success, message: 'success_send_ticket'.tr);
    } else {
      Get.back();
      appSnackBar(
          messageType: MessageTypes.error, message: 'send_ticket_already'.tr);
    }
  }

  CustomDialog.getInstance().dialogcontent(
    barrierDismissible: true,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        KeyboardListener(
          focusNode: FocusNode(),
          autofocus: true,
          onKeyEvent: (KeyEvent event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              onPressed();
            }
          },
          child: Container(
            width: 90.w,
            padding: EdgeInsets.all(20.r),
            child: Obx(() => IgnorePointer(
                ignoring: authenticationController.loading.value,
                child: Stack(children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "account_unlock_request".tr,
                        style: TextStyle(
                            color: AppColor.black,
                            fontSize: 10.r,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.lock_person,
                        color: AppColor.amberLight,
                        size: Get.width * 0.06,
                      ),
                      SizedBox(
                        height: 5.r,
                      ),
                      Text(
                          '${'account_locked'.tr}\n${'account_unlock_request_message'.tr}',
                          textAlign: TextAlign.center,
                          style: AppStyle.textStyle(
                              fontSize: 9.r,
                              fontWeight: FontWeight.w500,
                              color: AppColor.lavenderGray)),
                      SizedBox(
                        height: 40.r,
                      ),
                      Column(
                        children: [
                          ButtonElevated(
                              text: 'yes'.tr,
                              height: 0.04.sh,
                              width: 77.w,
                              borderRadius: 9,
                              backgroundColor: AppColor.cyanTeal,
                              showBoxShadow: true,
                              textStyle: AppStyle.textStyle(
                                  color: Colors.white,
                                  fontSize: 3.sp,
                                  fontWeight: FontWeight.normal),
                              onPressed: onPressed),
                          SizedBox(
                            height: 10.r,
                          ),
                          ButtonElevated(
                              text: 'cancel'.tr,
                              width: 77.w,
                              height: 0.04.sh,
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
                  authenticationController.loading.value
                      ? const LoadingWidget()
                      : Container(),
                ]))),
          ),
        ),
      ],
    ),
    context: Get.context!,
  );
}

void showPassWordErrorDialog({required String message}) {
  DatabaseSettingController databaseSettingController =
      Get.isRegistered<DatabaseSettingController>()
          ? Get.find<DatabaseSettingController>()
          : Get.put(DatabaseSettingController.getInstance());
  // CustomDialog.getInstance().dialog(
  //     title: 'support_ticket'.tr,
  //     buttonheight: 0.04.sh,
  //     contentPadding: 20.r,
  //     message: "${'technical_support_ticket'.tr}\n\n$message",
  //     primaryButtonText: 'yes'.tr,
  //     buttonwidth: 77.w,
  //     fontSizetext: 9.r,
  //     fontSizetital: 10.r,
  //     icon: Icons.contact_support_rounded,
  //     onPressed: () async {
  //       await databaseSettingController
  //           .sendTicket(
  //               subscriptionId:
  //                   SharedPr.subscriptionDetailsObj!.subscriptionId.toString(),
  //               message: message)
  //           .then((value) {
  //         if (value.status) {
  //           SharedPr.setNotificationObj(
  //               notificationHelperObj: NotificationHelper(sendTicket: true));
  //           Get.back();
  //           appSnackBar(
  //               message: 'success_send_ticket'.tr,
  //               messageType: MessageTypes.success);
  //         } else {
  //           appSnackBar(
  //             message: value.message!,
  //           );
  //         }
  //       });
  //     });
  supportTicketDialog(
      context: Get.context!,
      message: message,
      icon: Icons.contact_support_rounded,
      onPressed: () async {
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
            appSnackBar(
                message: 'success_send_ticket'.tr,
                messageType: MessageTypes.success);
          } else {
            appSnackBar(
              message: value.message!,
            );
          }
        });
      });
}
