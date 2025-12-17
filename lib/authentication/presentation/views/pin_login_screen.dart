import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/app_theme.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/app_text_field.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/presentation/widgets/numberic_item.dart';
import 'package:yousentech_authentication/authentication/utils/pin_shortcut_action.dart';
import 'package:yousentech_authentication/authentication/utils/shortcut_pin_numbers.dart';

class PINLoginScreen extends StatefulWidget {
  const PINLoginScreen({super.key});

  @override
  State<PINLoginScreen> createState() => _PINLoginScreenState();
}

class _PINLoginScreenState extends State<PINLoginScreen> {
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.setHeight(55)),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Center(
                      child: Builder(
                        builder: (context) {
                          return SizeProvider(
                            baseSize: Size(
                              context.setWidth(454.48),
                              context.setHeight(550),
                            ),
                            width: context.setWidth(454.48),
                            height: context.setHeight(550),
                            child: Container(
                              width: context.setWidth(454.48),
                              height: context.setHeight(550),
                              decoration: ShapeDecoration(
                                color: Theme.of(context).extension<CustomTheme>()!.preferredSizeBackground,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.white.withValues(alpha: 0.50),
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
                                      horizontal: context.setWidth(48.07)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: context.setHeight(34.05)),
                                      Center(
                                        child: Text(
                                          'login'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
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
                                              color: Theme.of(context).textTheme.labelSmall!.color,
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
                                              TextSpan(text: 'enter_pin'.tr),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: context.setHeight(15)),
                                      Center(
                                        child: ContainerTextField(
                                              focusNode: pinNumberFocus,
                                              controller:
                                                  authenticationController
                                                      .pinKeyController,
                                              labelText: 'pin_number'.tr,
                                              isPIN: true,
                                              isAddOrEdit: false,
                                              readOnly: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              width: context.setWidth(
                                                250,
                                              ),
                                              height: context.setHeight(
                                                51.28,
                                              ),
                                              fontSize: context.setSp(16),
                                              testFontSize: context.setSp(19),
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
                                              fillColor: null,
                                              hintcolor: Theme.of(context).extension<CustomTheme>()!.hintcolor,
                                              color: const Color(0xFF16A6B7),
                                              borderRadius:
                                                  context.setMinSize(8.01),
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
                                                        package:
                                                            'shared_widgets',
                                                        width:
                                                            context.setWidth(
                                                          21.63,
                                                        ),
                                                        height:
                                                            context.setHeight(
                                                          21.63,
                                                        ),
                                                        color: SharedPr
                                                                .isDarkMode!
                                                            ? Colors.white
                                                                .withValues(
                                                                    alpha:
                                                                        0.66)
                                                            : const Color(
                                                                0xFFD9D9D9),
                                                      )
                                                    : SvgPicture.asset(
                                                        AppImages.eyeClosed,
                                                        package:
                                                            'shared_widgets',
                                                        width:
                                                            context.setWidth(
                                                          21.63,
                                                        ),
                                                        height:
                                                            context.setHeight(
                                                          21.63,
                                                        ),
                                                        color: SharedPr
                                                                .isDarkMode!
                                                            ? Colors.white
                                                                .withValues(
                                                                    alpha:
                                                                        0.66)
                                                            : const Color(
                                                                0xFFD9D9D9),
                                                      ),
                                              ),
                                              obscureText:
                                                  flag ? false : true,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  errorMessage =
                                                      'required_message_f'
                                                          .trParams({
                                                    'field_name':
                                                        'pin_number'.tr,
                                                  });
                                                  return "";
                                                }
                                                return null;
                                              },
                                            )
                                          
                                      ),

                                      SizedBox(
                                        height: context.setHeight(10),
                                      ),
                                      Expanded(
                                        child: NumbericItems(
                                            contextApp: context,
                                            authenticationController:
                                                authenticationController,
                                          ),
                                      ),
                                      
                                      // NumbericItems(
                                      //         authenticationController:
                                      //             authenticationController,
                                      //       ),

                                      
                                      if (SharedPr.chosenUserObj!.pinCodeLock! < 3)
                                        GetBuilder<AuthenticationController>(
                                          id: "choosePin",
                                          builder: (_) {
                                            return Padding(
                                              padding: EdgeInsets.only(bottom:context.setHeight(15),
                                              top: context.setHeight(13)
                                              ),
                                              child: InkWell(
                                                onTap: SharedPr.chosenUserObj!
                                                            .pinCodeLock! <
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
                                                        19.23,
                                                      ),
                                                      height: context
                                                          .setHeight(19.23),
                                                    ),
                                                    Text(
                                                      "switch_to_username_login"
                                                          .tr,
                                                      style: TextStyle(
                                                        color:Theme.of(context).textTheme.labelSmall!.color,
                                                        fontSize: context.setSp(12.82),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
      ),
    );
  }
}
