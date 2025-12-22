import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:remote_database_setting/remote_database_setting/domain/remote_database_setting_viewmodel.dart';
import 'package:remote_database_setting/remote_database_setting/presentation/create_support_ticket.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_enums.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/app_lists.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/config/app_theme.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/utils/login_helper.dart';

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
  AuthenticationController authenticationController = Get.put(
    AuthenticationController.getInstance(),
  );
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  int countErrors = 0;
  bool flag = false;
  var userNameFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    userNameFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => 
        IgnorePointer(
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
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: context.setHeight(83)),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'assets/image/logo.svg',
                        //   fit: BoxFit.cover,
                        //   width: context.setWidth(203.06),
                        //   height: context.setHeight(74.48),
                        // ),
                        // SizedBox(height: context.setHeight(35.52)),
                        Builder(
                          builder: (context) {
                            return SizeProvider(
                              baseSize: Size(
                                context.setWidth(454.48),
                                context.setHeight(470),
                              ),
                              width: context.setWidth(454.48),
                              height: context.setHeight(470),
                              child: Container(
                                width: context.setWidth(454.48),
                                height: context.setHeight(470),
                                decoration: ShapeDecoration(
                                  color: Get.find<ThemeController>().isDarkMode.value ?AppColor.black.withValues(alpha: 0.17):AppColor.white ,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color:
                                          Colors.white.withValues(alpha: 0.50),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      context.setMinSize(33),
                                    ),
                                  ),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: context.setWidth(48.87)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: context.setHeight(39.38)),
                                        Center(
                                          child: Text(
                                            'login'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Get.find<ThemeController>().isDarkMode.value?AppColor.white:AppColor.black,
                                              fontSize: context.setSp(20.03),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: context.setHeight(16)),
                                        Center(
                                          child: RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                              color: Color(0xFFB1B3BC),
                                                fontSize: context.setSp(14.42),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(text: 'hi'.tr),
                                                TextSpan(
                                                  text:
                                                      ' ${SharedPr.chosenUserObj!.name}  ',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF16A6B7),
                                                    fontSize: context.setSp(16),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'enter_username_and_password'
                                                          .tr,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: context.setHeight(35)),

                                        // email
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  context.setWidth(10.42)),
                                          child: Text(
                                            'email'.tr,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFFB1B3BC),
                                              fontSize: context.setSp(12.82),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: ContainerTextField(
                                          focusNode: userNameFocusNode,
                                          controller: usernameController,
                                          labelText: 'email'.tr,
                                          keyboardType: TextInputType.text,
                                          inputFormatters: [
                                            TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                              final text = newValue.text;

                                              // لا يسمح إلا بحروف + أرقام + @ + .
                                              final allowed =
                                                  RegExp(r'^[a-zA-Z0-9@.]*$');
                                              if (!allowed.hasMatch(text)) {
                                                return oldValue; // منع الإدخال
                                              }

                                              // منع تكرار @
                                              if (text.split('@').length > 2) {
                                                return oldValue;
                                              }

                                              return newValue;
                                            }),
                                          ],
                                          width: context.screenWidth,
                                          height: context.setHeight(51.28),
                                          fontSize: context.setSp(
                                            14,
                                          ),
                                          contentPadding: EdgeInsets.fromLTRB(
                                            context.setWidth(
                                              14.82,
                                            ),
                                            context.setHeight(
                                              15.22,
                                            ),
                                            context.setWidth(
                                              14.82,
                                            ),
                                            context.setHeight(
                                              15.22,
                                            ),
                                          ),
                                          showLable: false,
                                          iconcolor: const Color(
                                            0xFF16A6B7,
                                          ),
                                          borderColor:const Color(0xFFC2C3CB),
                                          fillColor:Get.find<ThemeController>().isDarkMode.value ? const Color(0xFF2B2B2B): Colors.white.withValues(alpha: 0.43),
                                          hintcolor: const Color(0xFFC2C3CB),
                                          color: Get.find<ThemeController>().isDarkMode.value ?AppColor.white :AppColor.black ,
                                          isAddOrEdit: true,
                                          borderRadius:
                                              context.setMinSize(8.01),
                                          hintText: 'email'.tr,
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: context.setWidth(
                                                14,
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                              AppImages.emaill,
                                              package: 'shared_widgets',
                                              color: const Color(
                                                0xFF16A6B7,
                                              ),
                                              width: context.setWidth(
                                                21.63,
                                              ),
                                              height: context.setHeight(
                                                21.63,
                                              ),
                                            ),
                                          ),
                                          
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              errorMessage =
                                                  'required_message'.trParams({
                                                'field_name': 'email'.tr,
                                              });
                                              countErrors++;
                                              return "";
                                            }
                                            if (value !=
                                                SharedPr
                                                    .chosenUserObj!.userName) {
                                              errorMessage =
                                                  'user_does_not_match'
                                                      .trParams({
                                                'field_name': 'email'.tr,
                                              });
                                              countErrors++;
                                              return "";
                                            }
                                            return null;
                                          },
                                        )),

                                        // password
                                        SizedBox(height: context.setHeight(16)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  context.setWidth(10.42)),
                                          child: Text(
                                            SharedPr.isForgetPass!
                                                ? 'otp_password'.tr
                                                : 'password'.tr,
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFFB1B3BC),
                                              fontSize: context.setSp(12.82),
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),

                                        GetBuilder<AuthenticationController>(
                                          builder: (_) {
                                            return Center(
                                                child: ContainerTextField(
                                              controller: passwordController,
                                              labelText: SharedPr.isForgetPass!
                                                  ? 'otp_password'.tr
                                                  : 'password'.tr,
                                              keyboardType: TextInputType.text,
                                              width: context.screenWidth,
                                              height: context.setHeight(51.28),
                                              fontSize: context.setSp(
                                                14,
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                context.setWidth(
                                                  14.82,
                                                ),
                                                context.setHeight(
                                                  15.22,
                                                ),
                                                context.setWidth(
                                                  14.82,
                                                ),
                                                context.setHeight(
                                                  15.22,
                                                ),
                                              ),
                                              showLable: false,
                                              iconcolor: const Color(
                                                0xFF16A6B7,
                                              ),
                                          borderColor:const Color(0xFFC2C3CB),
                                          fillColor:Get.find<ThemeController>().isDarkMode.value ? const Color(0xFF2B2B2B): Colors.white.withValues(alpha: 0.43),
                                          hintcolor: const Color(0xFFC2C3CB),
                                          color: Get.find<ThemeController>().isDarkMode.value ?AppColor.white :AppColor.black,
                                              isAddOrEdit: true,
                                              borderRadius:
                                                  context.setMinSize(8.01),
                                              hintText: SharedPr.isForgetPass!
                                                  ? 'otp_password'.tr
                                                  : 'password'.tr,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: context.setWidth(
                                                    14,
                                                  ),
                                                ),
                                                child: SvgPicture.asset(
                                                  AppImages.lockOn,
                                                  package: 'shared_widgets',
                                                  color: const Color(
                                                    0xFF16A6B7,
                                                  ),
                                                  width: context.setWidth(
                                                    21.63,
                                                  ),
                                                  height: context.setHeight(
                                                    21.63,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    flag = !flag;
                                                  });
                                                },
                                                icon: flag
                                                    ? SvgPicture.asset(
                                                        AppImages.eyeOpen,
                                                        package:
                                                            'shared_widgets',
                                                        width: context.setWidth(
                                                          21.63,
                                                        ),
                                                        height:
                                                            context.setHeight(
                                                          21.63,
                                                        ),
                                                        color: const Color(
                                                          0xFF16A6B7,
                                                        ),
                                                      )
                                                    : SvgPicture.asset(
                                                        AppImages.eyeClosed,
                                                        package:
                                                            'shared_widgets',
                                                        width: context.setWidth(
                                                          21.63,
                                                        ),
                                                        height:
                                                            context.setHeight(
                                                          21.63,
                                                        ),
                                                        color: const Color(
                                                          0xFF16A6B7,
                                                        ),
                                                      ),
                                              ),
                                              obscureText: flag ? false : true,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  errorMessage =
                                                      'required_message_f'
                                                          .trParams({
                                                    'field_name':
                                                        SharedPr.isForgetPass!
                                                            ? 'otp_password'.tr
                                                            : 'password'.tr,
                                                  });
                                                  return "";
                                                }
                                                return null;
                                              },
                                            ));
                                          },
                                        ),

                                        SizedBox(height: context.setHeight(35)),
                                        // for forgetPass
                                        SizedBox(
                                          height: context.setHeight(19.23),
                                          width: context.screenWidth,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GetBuilder<
                                                      AuthenticationController>(
                                                  id: "choosePin",
                                                  builder: (_) {
                                                    return InkWell(
                                                      onTap: SharedPr
                                                                  .chosenUserObj!
                                                                  .pinCodeLock! <
                                                              3
                                                          ? () {
                                                              authenticationController
                                                                  .setChoosePin();
                                                            }
                                                          : null,
                                                      child: Row(
                                                        spacing: context
                                                            .setWidth(6.41),
                                                        children: [
                                                          SvgPicture.asset(
                                                            AppImages.signOut,
                                                            package:
                                                                'shared_widgets',
                                                            fit: BoxFit.cover,
                                                            width: context
                                                                .setWidth(
                                                              19.23,
                                                            ),
                                                            height: context
                                                                .setHeight(
                                                              19.23,
                                                            ),
                                                          ),
                                                          Text(
                                                            "switch_to_pin_login"
                                                                .tr,
                                                            style: TextStyle(
                                                              color:  Color(0xFFB1B3BC),
                                                              fontSize:
                                                                  context.setSp(
                                                                12.82,
                                                              ),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                              InkWell(
                                                onTap: () {
                                                  forgetPasswordDialog(
                                                    context: context,
                                                    authenticationController:
                                                        authenticationController,
                                                  );
                                                },
                                                child: Text(
                                                  "forget_password".tr,
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF16A6B7,
                                                    ),
                                                    fontSize: context.setSp(
                                                      12.82,
                                                    ),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: context.setHeight(35.0)),

                                        // log In
                                        Center(
                                          child: Focus(
                                              autofocus: true,
                                              child: InkWell(
                                                onTap: onPressed,
                                                child: Container(
                                                  width: context.screenWidth,
                                                  height: context.setHeight(
                                                    47.27,
                                                  ),
                                                  alignment: Alignment.center,
                                                  decoration: ShapeDecoration(
                                                    color: const Color(
                                                      0xFF16A6B7,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        context.setMinSize(
                                                          7.21,
                                                        ),
                                                      ),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x4C16A6B7),
                                                        blurRadius: 24.04,
                                                        offset: Offset(0, 3.20),
                                                        spreadRadius: 0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    'login'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: context.setSp(
                                                        14.42,
                                                      ),
                                                      color: AppColor.white,
                                                      fontFamily: 'Tajawal',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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

  onPressed() async {
    countErrors = 0;
    LoginHelper.authenticateUsingUsernameAndPassword(
        formKey: _formKey,
        countErrors: countErrors,
        errorMessage: errorMessage,
        authenticationController: authenticationController,
        usernameController: usernameController,
        passwordController: passwordController,
        context: context);
  }
}

void showAccountLockDialog({
  required AuthenticationController authenticationController,
  required BuildContext context,
}) {
  onPressed() async {
    LoginHelper.sendTicketToEliminateAccountLock(
        authenticationController: authenticationController);
  }

  dialogcontent(
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
            height: context.setHeight(200),
            width: context.setWidth(454.48),
            padding: EdgeInsets.all(context.setMinSize(20)),
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
                            fontSize: context.setSp(10),
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.lock_person,
                        color: AppColor.amberLight,
                        size: Get.width * 0.06,
                      ),
                      SizedBox(
                        height: context.setHeight(10),
                      ),
                      Text(
                          '${'account_locked'.tr}\n${'account_unlock_request_message'.tr}',
                          textAlign: TextAlign.center,
                          style: AppStyle.textStyle(
                              fontSize: context.setSp(9),
                              fontWeight: FontWeight.w500,
                              color: AppColor.lavenderGray)),
                      SizedBox(
                        height: context.setHeight(20),
                      ),
                      Column(
                        children: [
                          ButtonElevated(
                              text: 'yes'.tr,
                              height: context.setHeight(200),
                              width: context.setWidth(77),
                              borderRadius: 9,
                              backgroundColor: AppColor.cyanTeal,
                              showBoxShadow: true,
                              textStyle: AppStyle.textStyle(
                                  color: Colors.white,
                                  fontSize: context.setSp(3),
                                  fontWeight: FontWeight.normal),
                              onPressed: onPressed),
                          SizedBox(
                            height: context.setHeight(10),
                          ),
                          ButtonElevated(
                              text: 'cancel'.tr,
                              width: context.setWidth(77),
                              height: context.setHeight(200),
                              borderRadius: 9,
                              borderColor: AppColor.paleAqua,
                              textStyle: AppStyle.textStyle(
                                  color: AppColor.slateGray,
                                  fontSize: context.setSp(3),
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
    context: context,
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
        LoginHelper.sendTicket(
            databaseSettingController: databaseSettingController,
            message: message);
      });
}

forgetPasswordDialog({
  required BuildContext context,
  required AuthenticationController authenticationController,
}) {
  return dialogcontent(
    barrierDismissible: true,
    content: Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: messageTypesIcon2[MessageTypes.warning]!.last as Color,
          ),
        ),
        borderRadius: BorderRadius.circular(context.setMinSize(15)),
      ),
      padding: EdgeInsets.all(context.setMinSize(10)),
      height: context.setHeight(200),
      width: context.setWidth(454.48),
      child: Builder(
        builder: (context) {
          return SizeProvider(
            baseSize: Size(context.setHeight(200), context.setHeight(450)),
            height: context.setHeight(200),
            width: context.setWidth(454.48),
            child: Obx(
              () => IgnorePointer(
                ignoring: authenticationController.loading.value,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        if (messageTypesIcon2[MessageTypes.warning]!.first !=
                            "") ...[
                          SizedBox(height: context.setHeight(10)),
                          SvgPicture.asset(
                            AppImages.information,
                            package: "shared_widgets",
                            clipBehavior: Clip.antiAlias,
                            fit: BoxFit.fill,
                            width: context.setWidth(50),
                            height: context.setHeight(50),
                          ),
                          SizedBox(height: context.setHeight(10)),
                          Text(
                            "confirm_reset_password".tr,
                            style: TextStyle(
                              color: Color(0xFFB1B3BC),
                              fontSize: context.setSp(14.42),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                        SizedBox(height: context.setHeight(30)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ButtonElevated(
                              text: "confirm_reset_password".tr,
                              width: context.setWidth(200),
                              borderRadius: context.setMinSize(9),
                              backgroundColor:
                                  messageTypesIcon2[MessageTypes.warning]!.last
                                      as Color,
                              textStyle: AppStyle.textStyle(
                                color: AppColor.white,
                                fontSize: context.setSp(14.42),
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w400,
                              ),
                              onPressed: () async {
                                LoginHelper.forgetPassword(
                                  authenticationController:
                                      authenticationController,
                                );
                              },
                            ),
                            SizedBox(width: context.setHeight(10)),
                            ButtonElevated(
                              text: 'cancel'.tr,
                              width: context.setWidth(200),
                              borderRadius: context.setMinSize(9),
                              borderColor: AppColor.paleAqua,
                              textStyle: AppStyle.textStyle(
                                color: AppColor.slateGray,
                                fontSize: context.setSp(14.42),
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.w400,
                              ),
                              onPressed: () async {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    authenticationController.loading.value
                        ? const LoadingWidget()
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
    context: context,
  );
}
