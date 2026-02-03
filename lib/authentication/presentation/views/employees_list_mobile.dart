import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_close_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';

import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_pos_token/token_settings/domain/token_viewmodel.dart';

class EmployeesListScreenMobile extends StatefulWidget {
  const EmployeesListScreenMobile({super.key});

  @override
  State<EmployeesListScreenMobile> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreenMobile> {
  final TokenController tokenController = Get.put(
    TokenController.getInstance(),
  );
  final AuthenticationController authenticationController = Get.put(
    AuthenticationController.getInstance(),
  );
  late FocusNode _focusNode;
  final ScrollController _scrollController = ScrollController();
  bool lightMode = true;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      flutterWindowCloseshow(context);
      _focusNode.requestFocus();
      await tokenController.loadEmployeesBasedOnToken(token: SharedPr.token!);
      tokenController.update(["update_employees"]);
    });
  }

  @override
  void didUpdateWidget(covariant EmployeesListScreenMobile oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode.unfocus();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          if (SharedPr.userObj == null) {
            Get.reset();
            SystemNavigator.pop();
            return false;
          }
          return true;
        },
        child: IgnorePointer(
          ignoring: tokenController.isLoading.value,
          child: Stack(
            children: [
              SafeArea(
                child: Scaffold(
                  backgroundColor: Get.find<ThemeController>().isDarkMode.value
                      ? AppColor.darkModeBackgroundColor
                      : AppColor.white,
                  appBar: customAppBar(
                    isMobile: true,
                    context: context,
                    onDarkModeChanged: () {},
                  ),
                  body: GetBuilder<TokenController>(
                      id: "update_employees",
                      builder: (contextx) {
                        return Padding(
                          padding: EdgeInsets.all(context.setMinSize(16.92)),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: context.setHeight(40)),
                                Center(
                                  child: Text(
                                    'employee_list'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SansBold',
                                      color: Get.find<ThemeController>()
                                              .isDarkMode
                                              .value
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: context.setSp(14),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.setHeight(16)),
                                Center(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${'welcomeBack'.tr} ${'to'.tr} ",
                                        ),
                                        TextSpan(
                                          text: '${'qimam'.tr}  ',
                                          style: TextStyle(
                                            color: AppColor.appColor,
                                            fontSize: context.setSp(12),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'choose_your_account'.tr,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF9F9FA5),
                                      fontFamily: 'SansRegular',
                                      fontSize: context.setSp(12),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.setHeight(35)),
                                if (tokenController.isLoading.value ||
                                    tokenController.result == null) ...[
                                  Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.cyanTeal,
                                    ),
                                  ),
                                  SizedBox(height: context.setHeight(10)),
                                  Center(
                                    child: Text(
                                      'loading'.tr,
                                      style: TextStyle(
                                        color: Color(0xFF9F9FA5),
                                        fontSize: context.setSp(12),
                                        fontFamily: "SansMedium",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ] else if (!tokenController.result.status) ...[
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red[400],
                                        size: context.setWidth(50),
                                      ),
                                      SizedBox(
                                        height: context.setHeight(10),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                          context.setMinSize(8),
                                        ),
                                        child: Text(
                                          tokenController.result.message ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF9F9FA5),
                                            fontSize: context.setSp(
                                              14.42,
                                            ),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.setHeight(10),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(
                                          context.setMinSize(8),
                                        ),
                                        child: ButtonElevated(
                                          text: "Update_page".tr,
                                          width: context.screenWidth,
                                          backgroundColor: Colors.red[400],
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: context.setSp(
                                              12,
                                            ),
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onPressed: () async {
                                            tokenController.isLoading.value =
                                                true;
                                            await tokenController
                                                .loadEmployeesBasedOnToken(
                                              token: SharedPr.token!,
                                            );
                                            tokenController.update([
                                              "update_employees",
                                            ]);
                                            tokenController.isLoading.value =
                                                false;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  if (tokenController.finalResult.isEmpty) ...[
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.no_accounts_outlined,
                                          color: AppColor.cyanTeal,
                                          size: context.setWidth(50),
                                        ),
                                        Text(
                                          'empty_list'.tr,
                                          style: TextStyle(
                                            color: Color(0xFF9F9FA5),
                                            fontFamily: "SansMedium",
                                            fontSize: context.setSp(
                                              12,
                                            ),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    ...List.generate(
                                      tokenController.finalResult.length,
                                      (index) {
                                        return GestureDetector(
                                            onTap: () {
                                              tokenController.onSelectEmployee(
                                                index,
                                                authenticationController,
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      context.setHeight(10)),
                                              child: Container(
                                                  width: double.infinity,
                                                  height: context.setHeight(60),
                                                  padding: EdgeInsets.all(
                                                      context.setMinSize(6)),
                                                  decoration: ShapeDecoration(
                                                    color: Get.find<
                                                                ThemeController>()
                                                            .isDarkMode
                                                            .value
                                                        ? const Color(
                                                            0xFF353535)
                                                        : AppColor.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        width: 1.06,
                                                        color: Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                            ? const Color(
                                                                0xFF353535)
                                                            : const Color(
                                                                0xFFE8E8E8),
                                                      ),
                                                      borderRadius: BorderRadius
                                                          .circular(context
                                                              .setMinSize(10)),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    spacing:
                                                        context.setWidth(12.69),
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(context
                                                                    .setMinSize(
                                                                        15)),
                                                        child: Container(
                                                            color: Get.find<
                                                                        ThemeController>()
                                                                    .isDarkMode
                                                                    .value
                                                                ? const Color(
                                                                    0xFF2A2A2A)
                                                                : Color(
                                                                    0xFFECEFF2),
                                                            width: context
                                                                .setWidth(
                                                                    50.75),
                                                            height: context
                                                                .setWidth(
                                                                    50.75),
                                                            child: Center(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .all(context
                                                                        .setMinSize(
                                                                            10)),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  AppImages
                                                                      .person,
                                                                  package:
                                                                      'shared_widgets',
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  color: Get.find<
                                                                              ThemeController>()
                                                                          .isDarkMode
                                                                          .value
                                                                      ? null
                                                                      : const Color(
                                                                          0xFF666C6D),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${tokenController.finalResult[index].name}',
                                                          style: TextStyle(
                                                            color: Get.find<
                                                                        ThemeController>()
                                                                    .isDarkMode
                                                                    .value
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontFamily:
                                                                'SansMedium',
                                                            fontSize:
                                                                context.setSp(
                                                              12,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ));
                                      },
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Obx(
                () => tokenController.isLoading.value
                    ? const LoadingWidget()
                    : Container(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
