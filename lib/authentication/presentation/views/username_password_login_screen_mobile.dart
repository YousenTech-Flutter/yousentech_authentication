import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_snack_bar.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/response_result.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/presentation/views/username_password_login_screen.dart';
import 'package:yousentech_authentication/authentication/utils/login_helper.dart';

class UsernameAndPasswordLoginScreenMobile extends StatefulWidget {
  const UsernameAndPasswordLoginScreenMobile({super.key});

  @override
  State<UsernameAndPasswordLoginScreenMobile> createState() =>
      _UsernameAndPasswordLoginScreenState();
}

class _UsernameAndPasswordLoginScreenState
    extends State<UsernameAndPasswordLoginScreenMobile> {
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
    return Obx(
      () => IgnorePointer(
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
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(context.setMinSize(16.92)),
                  child: Column(
                    children: [
                      SizedBox(height: context.setHeight(40)),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'login'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Get.find<ThemeController>()
                                          .isDarkMode
                                          .value
                                      ? AppColor.white
                                      : AppColor.black,
                                  fontSize: context.setSp(20.03),
                                  fontFamily: 'SansBold',
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
                                    fontFamily: 'SansRegular',
                                    fontSize: context.setSp(14.42),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: 'hi'.tr),
                                    TextSpan(
                                      text:
                                          ' ${SharedPr.chosenUserObj!.name}  ',
                                      style: TextStyle(
                                        color: AppColor.appColor,
                                        fontSize: context.setSp(16),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'enter_username_and_password'.tr,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: context.setHeight(35)),

                            // email
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.setWidth(10.42)),
                              child: Text(
                                'email'.tr,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFFB1B3BC),
                                  fontFamily: "SansMedium",
                                  fontSize: context.setSp(12.82),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            ContainerTextField(
                              focusNode: userNameFocusNode,
                              controller: usernameController,
                              labelText: 'email'.tr,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  final text = newValue.text;

                                  // لا يسمح إلا بحروف + أرقام + @ + .
                                  final allowed = RegExp(r'^[a-zA-Z0-9@.]*$');
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
                              iconcolor: AppColor.appColor,
                              borderColor: const Color(0xFFC2C3CB),
                              fillColor:
                                  Get.find<ThemeController>().isDarkMode.value
                                      ? const Color(0xFF2B2B2B)
                                      : Colors.white.withValues(alpha: 0.43),
                              hintcolor: const Color(0xFFC2C3CB),
                              color:
                                  Get.find<ThemeController>().isDarkMode.value
                                      ? AppColor.white
                                      : AppColor.black,
                              isAddOrEdit: true,
                              borderRadius: context.setMinSize(8.01),
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
                                  color: AppColor.appColor,
                                  width: context.setWidth(
                                    21.63,
                                  ),
                                  height: context.setHeight(
                                    21.63,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  errorMessage = 'required_message'.trParams({
                                    'field_name': 'email'.tr,
                                  });
                                  countErrors++;
                                  return "";
                                }
                                if (value != SharedPr.chosenUserObj!.userName) {
                                  errorMessage =
                                      'user_does_not_match'.trParams({
                                    'field_name': 'email'.tr,
                                  });
                                  countErrors++;
                                  return "";
                                }
                                return null;
                              },
                            ),

                            // password
                            SizedBox(height: context.setHeight(16)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.setWidth(10.42)),
                              child: Text(
                                SharedPr.isForgetPass!
                                    ? 'otp_password'.tr
                                    : 'password'.tr,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFFB1B3BC),
                                  fontFamily: "SansMedium",
                                  fontSize: context.setSp(12.82),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            GetBuilder<AuthenticationController>(
                              builder: (_) {
                                return ContainerTextField(
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
                                  iconcolor: AppColor.appColor,
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
                                  borderRadius: context.setMinSize(8.01),
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
                                      color: AppColor.appColor,
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
                                            package: 'shared_widgets',
                                            width: context.setWidth(
                                              21.63,
                                            ),
                                            height: context.setHeight(
                                              21.63,
                                            ),
                                            color: AppColor.appColor,
                                          )
                                        : SvgPicture.asset(
                                            AppImages.eyeClosed,
                                            package: 'shared_widgets',
                                            width: context.setWidth(
                                              21.63,
                                            ),
                                            height: context.setHeight(
                                              21.63,
                                            ),
                                            color: AppColor.appColor,
                                          ),
                                  ),
                                  obscureText: flag ? false : true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      errorMessage =
                                          'required_message_f'.trParams({
                                        'field_name': SharedPr.isForgetPass!
                                            ? 'otp_password'.tr
                                            : 'password'.tr,
                                      });
                                      return "";
                                    }
                                    return null;
                                  },
                                );
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
                                  GetBuilder<AuthenticationController>(
                                      id: "choosePin",
                                      builder: (_) {
                                        return InkWell(
                                          onTap: SharedPr.chosenUserObj!
                                                      .pinCodeLock! <
                                                  3
                                              ? () {
                                                  authenticationController
                                                      .setChoosePin();
                                                }
                                              : null,
                                          child: Row(
                                            spacing: context.setWidth(6.41),
                                            children: [
                                              SvgPicture.asset(
                                                AppImages.pinLogin,
                                                package: 'shared_widgets',
                                                color: AppColor.appColor,
                                                fit: BoxFit.cover,
                                                width: context.setWidth(
                                                  18,
                                                ),
                                                height: context.setHeight(
                                                  18,
                                                ),
                                              ),
                                              Text(
                                                "switch_to_pin_login".tr,
                                                style: TextStyle(
                                                  color: Color(0xFFB1B3BC),
                                                  fontFamily: "SansMedium",
                                                  fontSize: context.setSp(
                                                    12.82,
                                                  ),
                                                  fontWeight: FontWeight.w400,
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
                                        color: AppColor.appColor,
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
                            SizedBox(height: context.setHeight(35.0)),

                            // log In
                            Focus(
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
                                      color: AppColor.appColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          context.setMinSize(
                                            7.21,
                                          ),
                                        ),
                                      ),
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
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )),
                            SizedBox(height: context.setHeight(35)),
                            Column(
                              spacing: context.setHeight(15),
                              children: [
                                Row(
                                  spacing: context.setWidth(10),
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: context.setHeight(1.06),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF323232)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'sign_in_with'.tr,
                                          style: TextStyle(
                                            color: Get.find<ThemeController>()
                                                    .isDarkMode
                                                    .value
                                                ? AppColor.white
                                                : Color(0xFFB1B3BC),
                                            fontSize: context.setSp(11.63),
                                            fontFamily: 'SansRegular',
                                            fontWeight: FontWeight.w400,
                                            height: 1.82,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: context.setHeight(1.06),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF323232)),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: context.setWidth(10),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async{
                                        ResponseResult result = await authenticationController.authenticateWithFingerprint();
                                        if(!result.status){
                                          appSnackBar( message: result.message);
                                          return;
                                        }
                                        onPressed(skipAuthenticate: true);
                                      },
                                      child: Container(
                                        width: context.setWidth(54),
                                        height: context.setHeight(54),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? Color(0xFF292929)
                                              : const Color(0xFFF5F5F5),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppImages.faceId,
                                            package: "shared_widgets",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        ResponseResult result = await authenticationController.authenticateWithFingerprint();
                                        if(!result.status){
                                          appSnackBar( message: result.message);
                                          return;
                                        }
                                        onPressed(skipAuthenticate: true);
                                      },
                                      child: Container(
                                        width: context.setWidth(54),
                                        height: context.setHeight(54),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? Color(0xFF292929)
                                              : const Color(0xFFF5F5F5),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AppImages.fingerPrinter,
                                            package: "shared_widgets",
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
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
    );
  }

  onPressed({bool skipAuthenticate = false}) async {
    if (skipAuthenticate) {
      LoginHelper.authenticateUsingFingerPrinterAndFaceId(
          authenticationController: authenticationController, context: context);
    } else {
      countErrors = 0;
      LoginHelper.authenticateUsingUsernameAndPassword(
          formKey: _formKey,
          countErrors: countErrors,
          errorMessage: errorMessage,
          authenticationController: authenticationController,
          usernameController: usernameController.text,
          passwordController: passwordController.text,
          context: context);
    }
  }
}
