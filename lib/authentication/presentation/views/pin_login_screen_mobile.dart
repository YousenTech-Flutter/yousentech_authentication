import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/app_sizes.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/presentation/widgets/numberic_item.dart';
import 'package:yousentech_authentication/authentication/utils/pin_shortcut_action.dart';
import 'package:yousentech_authentication/authentication/utils/shortcut_pin_numbers.dart';

class PINLoginScreenMobile extends StatefulWidget {
  const PINLoginScreenMobile({super.key});

  @override
  State<PINLoginScreenMobile> createState() => _PINLoginScreenState();
}

class _PINLoginScreenState extends State<PINLoginScreenMobile> {
  AuthenticationController authenticationController = Get.put(
    AuthenticationController.getInstance(),
  );
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(context.setMinSize(AppSizes.pagePadding)),
                      child: Column(
                        children: [
                          SizedBox(height: context.setHeight(AppSizes.topPagePadding)),
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  'login'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Get.find<ThemeController>()
                                            .isDarkMode
                                            .value
                                        ? Colors.white
                                        : Colors.black,
                                    
                                    fontSize: context.setSp(AppSizes.title),
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
                                      color: Color(0xFF9F9FA5),
                                      // fontSize: context.setSp(14.42),
                                      fontSize: context.setSp(AppSizes.subTitle),
                                      fontFamily: 'SansRegular',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: 'hi'.tr),
                                      TextSpan(
                                        text:
                                            ' ${SharedPr.chosenUserObj!.name}  ',
                                        style: TextStyle(
                                          color: const Color(0xFF16A6B7),
                                          fontSize: context.setSp(16),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(text: 'enter_pin'.tr),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: context.setHeight(15)),
                              ContainerTextField(
                                focusNode: pinNumberFocus,
                                controller:
                                    authenticationController.pinKeyController,
                                labelText: 'pin_number'.tr,
                                isPIN: true,
                                isAddOrEdit: false,
                                readOnly: true,
                                keyboardType: TextInputType.number,

                                testFontSize: context.setSp(AppSizes.textFieldNumber),
                                
                                fillColor: null,
                                hintcolor: const Color(0xFFC2C3CB),
                                color: AppColor.appColor,
                                
                                hintText: 'pin_number'.tr,
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
                                          color: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? AppColor.white
                                                  .withValues(alpha: 0.66)
                                              : AppColor.black,
                                          fit: BoxFit.contain
                                        )
                                      : SvgPicture.asset(
                                          AppImages.eyeClosed,
                                          package: 'shared_widgets',
                                          width: context.setWidth(
                                            AppSizes.iconTextField,
                                          ),
                                          height: context.setHeight(
                                            AppSizes.iconTextField,
                                          ),
                                          color: Get.find<ThemeController>()
                                                  .isDarkMode
                                                  .value
                                              ? AppColor.white
                                                  .withValues(alpha: 0.66)
                                              : AppColor.black,
                                          fit: BoxFit.contain
                                        ),
                                ),
                                obscureText: flag ? false : true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    errorMessage =
                                        'required_message_f'.trParams({
                                      'field_name': 'pin_number'.tr,
                                    });
                                    return "";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: context.setHeight(20),
                          ),
                          Expanded(
                            flex: 2,
                            child: NumbericItems(
                              contextApp: context,
                              fontFamily: 'SansMedium',
                              isMobile: true,
                              authenticationController:
                                  authenticationController,
                            ),
                          ),
                          SizedBox(height: context.setHeight(15)),
                          if (SharedPr.chosenUserObj!.pinCodeLock! < 3)
                            Expanded(
                              child: Align(
                                alignment: AlignmentGeometry.bottomCenter,
                                child: GetBuilder<AuthenticationController>(
                                  id: "choosePin",
                                  builder: (_) {
                                    return InkWell(
                                      onTap:
                                          SharedPr.chosenUserObj!.pinCodeLock! <
                                                  3
                                              ? () {
                                                  authenticationController
                                                      .setChoosePin();
                                                }
                                              : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: context.setWidth(
                                          6.41,
                                        ),
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.signOut,
                                            package: 'shared_widgets',
                                            fit: BoxFit.cover,
                                            width: context.setWidth(
                                              AppSizes.iconTextField,
                                            ),
                                            height: context.setHeight(AppSizes.iconTextField),
                                          ),
                                          Text(
                                            "switch_to_username_login".tr,
                                            style: TextStyle(
                                              color: Color(0xFF9F9FA5),
                                              fontFamily: 'SansMedium',
                                              // fontSize: context.setSp(12.82),
                                              fontSize: context.setSp(AppSizes.text),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: context.setHeight(15)),
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
}
