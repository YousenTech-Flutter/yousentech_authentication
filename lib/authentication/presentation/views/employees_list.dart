import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_images.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_close_dialog.dart';
import 'package:shared_widgets/shared_widgets/app_loading.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_provider.dart';

import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_pos_token/token_settings/domain/token_viewmodel.dart';

class EmployeesListScreen extends StatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
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
  void didUpdateWidget(covariant EmployeesListScreen oldWidget) {
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
    return IgnorePointer(
      ignoring: tokenController.isLoading.value,
      child: Stack(
        children: [
          SafeArea(
            child: Scaffold(
              appBar: customAppBar(
                context: context,
                onDarkModeChanged: () {
                  setState(() {});
                },
              ),
              backgroundColor: !SharedPr.isDarkMode!
                  ? Color(0xFFDDDDDD)
                  : AppColor.darkModeBackgroundColor,
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                                color: !SharedPr.isDarkMode!
                                    ? Colors.white
                                    : Colors.white.withValues(
                                        alpha: 0.01,
                                      ),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: Colors.white.withValues(
                                      alpha: 0.50,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    context.setMinSize(33),
                                  ),
                                ),
                              ),
                              child: GetBuilder<TokenController>(
                                  id: "update_employees",
                                  builder: (contextx) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: context.setHeight(39.38),
                                        ),
                                        Center(
                                          child: Text(
                                            'employee_list'.tr,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: SharedPr.isDarkMode!
                                                  ? Colors.white
                                                  : Color(0xFF2E2E2E),
                                              fontSize: context.setSp(20.03),
                                              fontFamily: 'Tajawal',
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
                                                    color: const Color(
                                                      0xFF16A6B7,
                                                    ),
                                                    fontSize: context.setSp(16),
                                                    fontFamily: 'Tajawal',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'choose_your_account'.tr,
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: SharedPr.isDarkMode!
                                                  ? Color(0xFFB1B3BC)
                                                  : Color(0xFF9F9FA5),
                                              fontSize: context.setSp(14.42),
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: context.setHeight(35)),
                                        if (tokenController.isLoading.value ||
                                            tokenController.result == null) ...[
                                          SizedBox(
                                              height: context.setHeight(40)),
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: AppColor.cyanTeal,
                                            ),
                                          ),
                                          SizedBox(
                                              height: context.setHeight(10)),
                                          Center(
                                            child: Text(
                                              'loading'.tr,
                                              style: TextStyle(
                                                color: SharedPr.isDarkMode!
                                                    ? Color(0xFFB1B3BC)
                                                    : Color(0xFF9F9FA5),
                                                fontSize: context.setSp(14.42),
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ] else if (!tokenController
                                            .result.status) ...[
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    context.setHeight(20),
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        context.setHeight(40),
                                                  ),
                                                  Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red[400],
                                                    size: context.setWidth(50),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        context.setHeight(10),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      context.setMinSize(8),
                                                    ),
                                                    child: Text(
                                                      tokenController
                                                              .result.message ??
                                                          '',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            SharedPr.isDarkMode!
                                                                ? Color(
                                                                    0xFFB1B3BC,
                                                                  )
                                                                : Color(
                                                                    0xFF9F9FA5,
                                                                  ),
                                                        fontSize: context.setSp(
                                                          14.42,
                                                        ),
                                                        fontFamily: 'Tajawal',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        context.setHeight(10),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                      context.setMinSize(8),
                                                    ),
                                                    child: ButtonElevated(
                                                      text: "Update_page".tr,
                                                      width:
                                                          context.screenWidth,
                                                      backgroundColor:
                                                          Colors.red[400],
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: context.setSp(
                                                          14.42,
                                                        ),
                                                        fontFamily: 'Tajawal',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      onPressed: () async {
                                                        tokenController
                                                            .isLoading
                                                            .value = true;
                                                        await tokenController
                                                            .loadEmployeesBasedOnToken(
                                                          token:
                                                              SharedPr.token!,
                                                        );
                                                        tokenController.update([
                                                          "update_employees",
                                                        ]);
                                                        tokenController
                                                            .isLoading
                                                            .value = false;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          if (tokenController
                                              .finalResult.isEmpty) ...[
                                            Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        context.setHeight(40),
                                                  ),
                                                  Icon(
                                                    Icons.no_accounts_outlined,
                                                    color: AppColor.cyanTeal,
                                                    size: context.setWidth(50),
                                                  ),
                                                  Text(
                                                    'empty_list'.tr,
                                                    style: TextStyle(
                                                      color: SharedPr
                                                              .isDarkMode!
                                                          ? Color(0xFFB1B3BC)
                                                          : Color(0xFF9F9FA5),
                                                      fontSize: context.setSp(
                                                        14.42,
                                                      ),
                                                      fontFamily: 'Tajawal',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ] else ...[
                                            Expanded(
                                              child: GridView.extent(
                                                maxCrossAxisExtent:
                                                    context.setWidth(106),
                                                childAspectRatio:
                                                    context.setWidth(106) /
                                                        context.setHeight(118),
                                                crossAxisSpacing:
                                                    context.setWidth(
                                                  19,
                                                ), // المسافة الأفقية بين العناصر
                                                mainAxisSpacing:
                                                    context.setHeight(
                                                  19,
                                                ), // المسافة العمودية بين العناصر
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: context.setWidth(
                                                    50.2,
                                                  ),
                                                ), // المسافة من الحواف
                                                children: List.generate(
                                                  tokenController
                                                      .finalResult.length,
                                                  (index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        final TokenController
                                                            tokenUpdateController =
                                                            Get.put(
                                                          TokenController
                                                              .getInstance(),
                                                        );
                                                        tokenUpdateController
                                                            .onSelectEmployee(
                                                          index,
                                                          authenticationController,
                                                        );
                                                      },
                                                      child:  Container(
                                                            decoration:
                                                                ShapeDecoration(
                                                              color: SharedPr
                                                                      .isDarkMode!
                                                                  ? const Color(
                                                                      0x2B555555,
                                                                    )
                                                                  : const Color(
                                                                      0xFFF6F6F6,
                                                                    ),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  context
                                                                      .setMinSize(
                                                                    16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              spacing: 12,
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  AppImages
                                                                      .person,
                                                                  package:
                                                                      'shared_widgets',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: context
                                                                      .setWidth(
                                                                    40,
                                                                  ),
                                                                  height: context
                                                                      .setHeight(
                                                                    45,
                                                                  ),
                                                                  color: SharedPr
                                                                          .isDarkMode!
                                                                      ? null
                                                                      : const Color(
                                                                          0xFF18BBCD,
                                                                        ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        context
                                                                            .setWidth(
                                                                      16,
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Tooltip(
                                                                    message:
                                                                        '${tokenController.finalResult[index].name}',
                                                                    child:
                                                                        Text(
                                                                      '${tokenController.finalResult[index].name}',
                                                                      style:
                                                                          TextStyle(
                                                                        color: SharedPr.isDarkMode!
                                                                            ? const Color(
                                                                                0xFFBABABA,
                                                                              )
                                                                            : const Color(
                                                                                0xFF6B6868,
                                                                              ),
                                                                        fontSize:
                                                                            context.setSp(
                                                                          12,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ],
                                    );
                                  }),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
  }
}
