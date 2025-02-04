import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/app_styles.dart';
import 'package:shared_widgets/shared_widgets/app_button.dart';
import 'package:shared_widgets/shared_widgets/app_close_dialog.dart';
import 'package:shared_widgets/shared_widgets/card_login.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:yousentech_pos_token/token_settings/domain/token_viewmodel.dart';

import '../../domain/authentication_viewmodel.dart';

class EmployeesListScreen extends StatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  final TokenController tokenController =
      Get.put(TokenController.getInstance());
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController.getInstance());
  late FocusNode _focusNode;
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  // final GlobalKey _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // tokenController.employeesList.value.requestFocus();
      tokenController.isLoading.value = true;
      _focusNode.requestFocus();
      tokenController.loadEmployeesBasedOnToken(token: SharedPr.token!);
      // if (_listKey.currentContext != null) {
      //   final renderBox = _listKey.currentContext!.findRenderObject() as RenderBox;
      //   setState(() {
      //     itemHeight = renderBox.size.height;
      //   });
      // }
    });
    //_data();
    flutterWindowCloseshow(context);
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
    // tokenController.employeesList.value.dispose();
    _focusNode.dispose();
    _focusNode.unfocus();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TokenController>(builder: (contextx) {
      return SafeArea(
          child: Scaffold(
              appBar: customAppBar(),
              backgroundColor: AppColor.white,
              body: Obx(() {
                if (tokenController.isLoading.value ||
                    tokenController.result == null) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CardLogin(children: [
                          Text(
                            'employee_list'.tr,
                            style: TextStyle(
                                fontSize: 12.r,
                                color: AppColor.charcoal,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 0.01.sh,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'welcomeBack'.tr,
                                  style: TextStyle(
                                      fontSize: 8.r,
                                      color: AppColor.lavenderGray,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Tajawal'),
                                ),
                                TextSpan(
                                  text: ' ${'to'.tr}  ',
                                  style: TextStyle(
                                      fontSize: 8.r,
                                      color: AppColor.lavenderGray,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Tajawal'),
                                ),
                                TextSpan(
                                  text: '${'qimam'.tr}  ',
                                  style: TextStyle(
                                      fontSize: 8.r,
                                      color: AppColor.cyanTeal,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Tajawal'),
                                ),
                                TextSpan(
                                  text: 'choose_your_account'.tr,
                                  style: TextStyle(
                                      fontSize: 8.r,
                                      color: AppColor.lavenderGray,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Tajawal'),
                                ),
                              ],
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: 0.02.sh,
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: AppColor.cyanTeal,
                            ),
                          ),
                          SizedBox(
                            height: 0.01.sh,
                          ),
                          Text(
                            'loading'.tr,
                            style: TextStyle(
                                fontSize: 10.r,
                                color: AppColor.lavenderGray,
                                fontWeight: FontWeight.w400),
                          ),
                        ]),
                      ],
                    ),
                  );
                } else if (!tokenController.result.status) {
                  return CardLogin(children: [
                    Expanded(
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[400],
                            size: 50.r,
                          ),
                          SizedBox(
                            height: 0.01.sh,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Text(
                              tokenController.result.message ?? '',
                              textAlign: TextAlign.center,
                              style: AppStyle.textStyle(
                                fontSize: 12.r,
                                fontWeight: FontWeight.w500,
                                color: AppColor.blackwithopacity,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.01.sh,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: ButtonElevated(
                        text: "Update_page".tr,
                        width: ScreenUtil().screenWidth,
                        backgroundColor: Colors.red[400],
                        textStyle: AppStyle.textStyle(
                          color: Colors.white,
                          fontSize: 10.r,
                          fontWeight: FontWeight.normal,
                        ),
                        onPressed: () {
                          tokenController.isLoading.value = true;
                          tokenController.loadEmployeesBasedOnToken(
                              token: SharedPr.token!);
                          // tokenController.onInit();
                          // print("object");
                        },
                      ),
                    ),
                  ]);
                } else {
                  if (tokenController.finalResult.isEmpty) {
                    return CardLogin(children: [
                      Text(
                        'employee_list'.tr,
                        style: TextStyle(
                            fontSize: 12.r,
                            color: AppColor.charcoal,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'welcomeBack'.tr,
                              style: TextStyle(
                                  fontSize: 8.r,
                                  color: AppColor.lavenderGray,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Tajawal'),
                            ),
                            TextSpan(
                              text: ' ${'to'.tr}  ',
                              style: TextStyle(
                                  fontSize: 8.r,
                                  color: AppColor.lavenderGray,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Tajawal'),
                            ),
                            TextSpan(
                              text: '${'qimam'.tr}  ',
                              style: TextStyle(
                                  fontSize: 8.r,
                                  color: AppColor.cyanTeal,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Tajawal'),
                            ),
                          ],
                        ),
                        softWrap:
                            true, // Allows text to wrap into the next line if needed
                        overflow: TextOverflow
                            .visible, // Ensures text wraps and doesn't overflow
                      ),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      Icon(
                        Icons.no_accounts_outlined,
                        color: AppColor.cyanTeal,
                        size: 50.r,
                      ),
                      Text(
                        'empty_list'.tr,
                        style: TextStyle(
                            fontSize: 9.r,
                            color: AppColor.lavenderGray,
                            fontWeight: FontWeight.w400),
                      ),
                    ]);
                  } else {
                    _focusNode.requestFocus();
                    return KeyboardListener(
                        focusNode: _focusNode,
                        onKeyEvent: (KeyEvent event) {
                          if (event is KeyDownEvent) {
                            if (_focusNode.hasFocus) {
                              // if (event is KeyDownEvent) {
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowDown) {
                                setState(() {
                                  if (_selectedIndex <
                                      tokenController.finalResult.length - 1) {
                                    _selectedIndex++;
                                    _scrollToIndex();
                                    // _scrollToIndex(_selectedIndex);
                                  }
                                });
                              } else if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowUp) {
                                setState(() {
                                  if (_selectedIndex > 0) {
                                    _selectedIndex--;
                                    _scrollToIndex();
                                    // _scrollToIndex(_selectedIndex);
                                  }
                                });
                              } else if (event.logicalKey ==
                                  LogicalKeyboardKey.enter) {
                                if (tokenController.finalResult.isNotEmpty) {
                                  // print('LogicalKeyboardKey.enter');
                                  // final selectedEmp = tokenController.finalResult[_selectedIndex];
                                  tokenController.onSelectEmployee(
                                      _selectedIndex, authenticationController);
                                  _focusNode.requestFocus();
                                }
                              }
                            }
                          }
                        },
                        child: Builder(builder: (context) {
                          return CardLogin(children: [
                            Text(
                              'employee_list'.tr,
                              style: TextStyle(
                                  fontSize: 12.r,
                                  color: AppColor.charcoal,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'welcomeBack'.tr,
                                    style: TextStyle(
                                        fontSize: 8.r,
                                        color: AppColor.lavenderGray,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Tajawal'),
                                  ),
                                  TextSpan(
                                    text: ' ${'to'.tr}  ',
                                    style: TextStyle(
                                        fontSize: 8.r,
                                        color: AppColor.lavenderGray,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Tajawal'),
                                  ),
                                  TextSpan(
                                    text: '${'qimam'.tr}  ',
                                    style: TextStyle(
                                        fontSize: 8.r,
                                        color: AppColor.cyanTeal,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Tajawal'),
                                  ),
                                  TextSpan(
                                    text: 'choose_your_account'.tr,
                                    style: TextStyle(
                                        fontSize: 8.r,
                                        color: AppColor.lavenderGray,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Tajawal'),
                                  ),
                                ],
                              ),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            SizedBox(
                              height: 0.01.sh,
                            ),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                // key: _listKey,
                                controller: _scrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  bool isSelected = _selectedIndex == index;
                                  // print(
                                  //     "selectedEmployeeIndex ${index == tokenController.selectedEmployeeIndex}");
                                  return Container(
                                    // color: index ==
                                    //         tokenController
                                    //             .selectedEmployeeIndex
                                    //     ? AppColor.cyanTeal.withOpacity(0.1)
                                    //     : null,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: isSelected
                                          ? AppColor.cyanTeal.withOpacity(0.15)
                                          : null,
                                    ),
                                    child: ListTile(
                                      // selected: index ==
                                      //     tokenController
                                      //         .selectedEmployeeIndex,
                                      onTap: () async {
                                        // if (kDebugMode) {
                                        //   print(
                                        //       "chosenUserObj ${tokenController.finalResult![index].toJson()}");
                                        // }
                                        tokenController.onSelectEmployee(
                                            index, authenticationController);
                                      },
                                      title: Text(
                                        tokenController
                                            .finalResult[index].name!,
                                        style: TextStyle(
                                            fontSize: 10.r,
                                            color: AppColor.lavenderGray,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      tileColor: _selectedIndex == index
                                          ? Colors.blue[100]
                                          : null,
                                      selected: _selectedIndex == index,
                                      leading: Icon(
                                        Icons.person_outline_rounded,
                                        size: 15.r,
                                        color: AppColor.charcoal,
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        size: 15.r,
                                        color: AppColor.charcoal,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 10.h,
                                    color: AppColor.roseQuartz,
                                  );
                                },
                                itemCount: tokenController.finalResult.length,
                              ),
                            ),
                          ]);
                        }));
                  }
                }
              })));
    });
  }

  void _scrollToIndex() {
    const itemHeight = 65.0;
    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;
    final itemTop = _selectedIndex * itemHeight;
    final itemBottom = itemTop + itemHeight;

    if (itemTop < scrollOffset) {
      _scrollController.animateTo(
        itemTop,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else if (itemBottom > scrollOffset + viewportHeight) {
      _scrollController.animateTo(
        itemBottom - viewportHeight,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }
}
