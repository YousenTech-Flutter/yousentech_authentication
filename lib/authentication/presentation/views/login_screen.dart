import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/presentation/views/pin_login_screen.dart';
import 'package:yousentech_authentication/authentication/presentation/views/username_password_login_screen.dart';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.find<ThemeController>().isDarkMode.value? AppColor.darkModeBackgroundColor: const Color(0xFFDDDDDD),
        appBar: customAppBar(
          context: context,
          onDarkModeChanged: () {
            // setState(() {});
          },
        ),
        body: GetBuilder<AuthenticationController>(
          id: "choosePin",
          builder: (context) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (!authenticationController.choosePin)
                        ?  UsernameAndPasswordLoginScreen()
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
}
