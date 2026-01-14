import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:shared_widgets/utils/responsive_helpers/device_utils.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/presentation/views/pin_login_screen.dart';
import 'package:yousentech_authentication/authentication/presentation/views/username_password_login_screen.dart';
import 'package:yousentech_authentication/authentication/presentation/views/username_password_login_screen_mobile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthenticationController authenticationController = Get.put(
    AuthenticationController.getInstance(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Get.find<ThemeController>().isDarkMode.value? AppColor.darkModeBackgroundColor:DeviceUtils.isMobile(context) ? AppColor.white:  const Color(0xFFDDDDDD),
            appBar: customAppBar(
              isMobile:  DeviceUtils.isMobile(context) ? true : false,
              context: context,
              onDarkModeChanged: () {
                // setState(() {});
              },
            ),
            body: GetBuilder<AuthenticationController>(
              id: "choosePin",
              builder: (autcontext) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (!authenticationController.choosePin)
                            ? DeviceUtils.isMobile(context) ? UsernameAndPasswordLoginScreenMobile(): UsernameAndPasswordLoginScreen()
                            : PINLoginScreen(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }
}
