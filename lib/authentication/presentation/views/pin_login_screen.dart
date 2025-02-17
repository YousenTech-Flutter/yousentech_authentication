import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:yousentech_authentication/authentication/presentation/widgets/numberic_item.dart';
import 'package:yousentech_authentication/authentication/utils/pin_shortcut_action.dart';
import 'package:yousentech_authentication/authentication/utils/shortcut_pin_numbers.dart';

import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/app_close_dialog.dart';
import 'package:shared_widgets/shared_widgets/card_login.dart';

import '../../domain/authentication_viewmodel.dart';

class PINLoginScreen extends StatefulWidget {
  const PINLoginScreen({super.key});

  @override
  State<PINLoginScreen> createState() => _PINLoginScreenState();
}

class _PINLoginScreenState extends State<PINLoginScreen> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController.getInstance());
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  FocusNode pinNumberFocus = FocusNode();
  bool flag = false;
  @override
  void dispose() {
    pinNumberFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authenticationController.pinKeyController.clear();
      pinNumberFocus.requestFocus();
    });
    flutterWindowCloseshow(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => IgnorePointer(
          ignoring: authenticationController.loading.value,
          child: Focus(
            focusNode: FocusNode(),
            child: Shortcuts(
                shortcuts: shortcutPINNumbers,
                child: Actions(
                    actions: pinShortcutAction(
                        authenticationController: authenticationController),
                    child: Stack(
                      children: [
                        Focus(
                            focusNode: pinNumberFocus,
                            child: CardLogin(
                              heightCard: 0.63.sh,
                              children: [
                                Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
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
                                          RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: 'hi'.tr,
                                                  style: TextStyle(
                                                    fontSize: 9.r,
                                                    color:
                                                        AppColor.lavenderGray,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Tajawal',
                                                    package:
                                                        'yousentech_authentication',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '  ${SharedPr.chosenUserObj!.name}  ',
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
                                                  text: 'enter_pin'.tr,
                                                  style: TextStyle(
                                                    fontSize: 9.r,
                                                    color:
                                                        AppColor.lavenderGray,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Tajawal',
                                                    package:
                                                        'yousentech_authentication',
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 0.01.sh,
                                          ),
                                          ContainerTextField(
                                            width: 0.15.sw,
                                            height: 30.h,
                                            controller: authenticationController
                                                .pinKeyController,
                                            iconcolor: AppColor.silverGray,
                                            borderRadius: 5.r,
                                            fontSize: 9.r,
                                            isPIN: true,
                                            readOnly: true,
                                            textAlign: TextAlign.center,
                                            hintcolor: AppColor.silverGray,
                                            borderColor: AppColor.silverGray,
                                            hintText: 'pin_number'.tr,
                                            obscureText: flag ? false : true,
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(8.0.r),
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
                                                          color: AppColor
                                                              .silverGray,
                                                          package:
                                                              'yousentech_authentication',
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
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                errorMessage =
                                                    'required_message'
                                                        .trParams({
                                                  'field_name': 'pin_number'.tr
                                                });
                                                return "";
                                              }
                                              return null;
                                            },
                                            labelText: '',
                                          ),
                                          SizedBox(
                                            height: 0.01.sh,
                                          ),
                                          NumbericItems(
                                            authenticationController:
                                                authenticationController,
                                          ),
                                          if (SharedPr
                                                  .chosenUserObj!.pinCodeLock! <
                                              3)
                                            GetBuilder<
                                                    AuthenticationController>(
                                                id: "choosePin",
                                                builder: (context) {
                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 0.01.sh,
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            authenticationController
                                                                .setChoosePin();
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/image/login_icon.svg',
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                package:
                                                                    'yousentech_authentication',
                                                                fit:
                                                                    BoxFit.fill,
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
                                                                width: 10.r,
                                                              ),
                                                              Text(
                                                                !authenticationController
                                                                        .choosePin
                                                                    ? "switch_to_pin_login"
                                                                        .tr
                                                                    : "switch_to_username_login"
                                                                        .tr,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        9.r,
                                                                    color: AppColor
                                                                        .charcoal,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  );
                                                }),
                                          SizedBox(
                                            height: 0.01.sh,
                                          ),
                                        ]))
                              ],
                            )),
                        authenticationController.loading.value
                            ? LoadingWidget(
                                height: 600.h,
                              )
                            : Container(),
                      ],
                    ))),
          ),
        ));
  }
}
