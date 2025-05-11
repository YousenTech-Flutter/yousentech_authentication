import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_localbackup/local_backup/config/app_enum.dart';
import 'package:pos_localbackup/local_backup/utils/local_backup_prompt.dart';
import 'package:pos_shared_preferences/models/authentication_data/login_info.dart';
import 'package:pos_shared_preferences/models/notification_helper_model.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:remote_database_setting/remote_database_setting/domain/remote_database_setting_viewmodel.dart';
import 'package:remote_database_setting/remote_database_setting/presentation/create_support_ticket.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_lists.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_close_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/shared_widgets/card_login.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:yousentech_authentication/authentication/presentation/widgets/change_password_screen.dart';
import 'package:yousentech_pos_dashboard/dashboard/src/presentation/views/home_page.dart';
import '../../domain/authentication_viewmodel.dart';

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
                      height: 0.5.sh,
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: AutofillGroup(
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
                                              fontFamily: 'Tajawal',
                                              package:
                                                  'yousentech_authentication',
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${SharedPr.chosenUserObj!.name}  ',
                                            style: TextStyle(
                                              fontSize: 9.r,
                                              color: AppColor.cyanTeal,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Tajawal',
                                              package:
                                                  'yousentech_authentication',
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'enter_username_and_password'
                                                .tr,
                                            style: TextStyle(
                                              fontSize: 9.r,
                                              color: AppColor.lavenderGray,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Tajawal',
                                              package:
                                                  'yousentech_authentication',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.02.sh,
                                  ),
                                  ContainerTextField(
                                    width: ScreenUtil().screenWidth,
                                    height: 30.h,
                                    controller: usernameController,
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(8.0.r),
                                      child: SvgPicture.asset(
                                        'assets/image/user-1.svg',
                                        package: 'yousentech_authentication',
                                        fit: BoxFit.scaleDown,
                                        color: AppColor.silverGray,
                                      ),
                                    ),
                                    iconcolor: AppColor.silverGray,
                                    focusNode: userNameFocusNode,
                                    borderRadius: 5.r,
                                    fontSize: 9.r,
                                    showLable: true,
                                    labelText: 'username'.tr,
                                    autofillHints: const [AutofillHints.email],
                                    keyboardType: TextInputType.emailAddress,
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
                                  GetBuilder<AuthenticationController>(
                                      builder: (context) {
                                    return ContainerTextField(
                                      showLable: true,
                                      labelText: SharedPr.isForgetPass!
                                          ? 'otp_password'.tr
                                          : 'password'.tr,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
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
                                                    package:
                                                        'yousentech_authentication',
                                                    fit: BoxFit.scaleDown,
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
                                      onFieldSubmitted: (value) {
                                        TextInput.finishAutofillContext();
                                      },
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
                                                          package:
                                                              'yousentech_authentication',
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          fit: BoxFit.fill,
                                                          width: 10.r,
                                                          height: 10.r,
                                                        ),
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
                                                                      width:
                                                                          50.r,
                                                                      height:
                                                                          50.r,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          5.r,
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
                                                                    height:
                                                                        10.r,
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
                                                                        messageTypesIcon2[MessageTypes.warning]!.last
                                                                            as Color,
                                                                    textStyle: AppStyle.textStyle(
                                                                        color: AppColor
                                                                            .white,
                                                                        fontSize: 10
                                                                            .r,
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
                                                                            message:
                                                                                responseResult.message,
                                                                            messageType: MessageTypes.success);
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
                                                                    text:
                                                                        'cancel'
                                                                            .tr,
                                                                    width:
                                                                        0.13.sw,
                                                                    borderColor:
                                                                        AppColor
                                                                            .paleAqua,
                                                                    textStyle: AppStyle.textStyle(
                                                                        color: AppColor
                                                                            .slateGray,
                                                                        fontSize: 10
                                                                            .r,
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
                        ),
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
    countErrors = 0;
    if (_formKey.currentState!.validate()) {
      ResponseResult responseResult = await authenticationController
          .authenticateUsingUsernameAndPassword(LoginInfo(
              userName: usernameController.text,
              password: passwordController.text));
      if (responseResult.status && responseResult.data.accountLock < 3) {
        if (SharedPr.isForgetPass!) {
          await authenticationController.countUsernameFailureAttempt(
              reset: true);
          responseResult.data.accountLock = 0;
          await SharedPr.setUserObj(userObj: responseResult.data);
          await SharedPr.setForgetPass(flage: false, otp: '');
          changePasswordDialog();
        } else {
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
        }
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
            } else {
              showAccountLockDialog();
            }
          } else {
            showAccountLockDialog();
          }
        } else {
          appSnackBar(message: responseResult.message);
          authenticationController.loading.value = false;
          return;
        }
      }
    } else {
      appSnackBar(
        message: countErrors > 1 ? 'enter_required_info'.tr : errorMessage!,
      );
    }
  }
}

void showAccountLockDialog() {
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
