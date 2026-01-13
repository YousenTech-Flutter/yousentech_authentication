import 'package:flutter/material.dart';
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
      return IgnorePointer(
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
                body: Center(
                  child: GetBuilder<TokenController>(
                      id: "update_employees",
                      builder: (contextx) {
                        return Padding(
                          padding: EdgeInsets.all(context.setMinSize(16.92)),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(
                                //   height: context.setHeight(39.38),
                                // ),
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
                                      fontSize: context.setSp(20.03),
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
                                            fontSize: context.setSp(16),
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
                                      fontSize: context.setSp(14.42),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: context.setHeight(35)),
                                if (tokenController.isLoading.value ||
                                    tokenController.result == null) ...[
                                  SizedBox(height: context.setHeight(40)),
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
                                        fontSize: context.setSp(14.42),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ] else if (!tokenController.result.status) ...[
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: context.setHeight(20),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: context.setHeight(40),
                                          ),
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
                                              tokenController.result.message ??
                                                  '',
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
                                                  14.42,
                                                ),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              onPressed: () async {
                                                tokenController
                                                    .isLoading.value = true;
                                                await tokenController
                                                    .loadEmployeesBasedOnToken(
                                                  token: SharedPr.token!,
                                                );
                                                tokenController.update([
                                                  "update_employees",
                                                ]);
                                                tokenController
                                                    .isLoading.value = false;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  if (tokenController.finalResult.isEmpty) ...[
                                    Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: context.setHeight(40),
                                          ),
                                          Icon(
                                            Icons.no_accounts_outlined,
                                            color: AppColor.cyanTeal,
                                            size: context.setWidth(50),
                                          ),
                                          Text(
                                            'empty_list'.tr,
                                            style: TextStyle(
                                              color: Color(0xFF9F9FA5),
                                              fontSize: context.setSp(
                                                14.42,
                                              ),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    ...List.generate(
                                      tokenController.finalResult.length,
                                      (index) {
                                        return InkWell(
                                            onTap: () {
                                              final TokenController
                                                  tokenUpdateController =
                                                  Get.put(
                                                TokenController.getInstance(),
                                              );
                                              tokenUpdateController
                                                  .onSelectEmployee(
                                                index,
                                                authenticationController,
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      context.setHeight(6.34)),
                                              child: Container(
                                                  width: double.infinity,
                                                  height:
                                                      context.setHeight(60),
                                                  padding: EdgeInsets.all(
                                                      context.setMinSize(10)),
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              context
                                                                  .setMinSize(
                                                                      16.92)),
                                                    ),
                                                    shadows: [
                                                      BoxShadow(
                                                        color:
                                                            Color(0x00000000),
                                                        blurRadius: 10.57,
                                                        offset: Offset(0, 4.23),
                                                        spreadRadius: 0,
                                                      )
                                                    ],
                                                  ),
                                                  child: Row(
                                                    spacing:
                                                        context.setWidth(12.69),
                                                    children: [
                                                      Container(
                                                        width: context.setWidth(54.98),
                                                        
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: const Color(
                                                              0xFFECEFF2),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius: BorderRadius
                                                                .circular(context
                                                                    .setMinSize(
                                                                        16.92)),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(context.setMinSize(5)),
                                                          child: SvgPicture.asset(
                                                            AppImages.person,
                                                            package:
                                                                'shared_widgets',
                                                            fit: BoxFit.cover,
                                                            color:Get.find<
                                                                    ThemeController>()
                                                                .isDarkMode
                                                                .value
                                                                ? AppColor.white
                                                                : const Color(0xFFC2C3CB),
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        spacing: context.setHeight(5),
                                                        children: [
                                                          Text(
                                                            '${tokenController.finalResult[index].name}',
                                                            style: TextStyle(
                                                              color: Get.find<
                                                                          ThemeController>()
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
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
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Text(
                                                            'No-${tokenController.finalResult[index].id}',
                                                            style: TextStyle(
                                                              color: AppColor.appColor,
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
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          )
                                                        ],
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
            ),
            Obx(
              () => tokenController.isLoading.value
                  ? const LoadingWidget()
                  : Container(),
            ),
          ],
        ),
      );
    });
  }
}
