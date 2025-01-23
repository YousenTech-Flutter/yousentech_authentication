import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousentech_authentication/authentication/presentation/views/pin_login_screen.dart';
import 'package:yousentech_authentication/authentication/presentation/views/username_password_login_screen.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/shared_widgets/custom_app_bar.dart';
import '../../domain/authentication_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool choosePin = false;
  AuthenticationController authenticationController =
      Get.put(AuthenticationController.getInstance());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(),
        backgroundColor: AppColor.white,
        body: GetBuilder<AuthenticationController>(
            id: "choosePin",
            builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (!authenticationController.choosePin)
                        ? const UsernameAndPasswordLoginScreen()
                        : const PINLoginScreen(),
                  ],
                ),
              );
            }),
        //  Stack(
        //   children: [
        //     const Positioned(left: -150, bottom: -50, child: AppBackground()),
        //     GetBuilder<AuthenticationController>(
        //       id: "choosePin",
        //       builder: (context) {
        //         return   Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         (!authenticationController.choosePin)
        //             ? const UsernameAndPasswordLoginScreen()
        //             : const PINLoginScreen(),

        //       ],
        //     );

        //         }),

        //     const Positioned(right: -150, top: -50, child: AppBackground()),
        //   ],
        // )
      ),
    );
  }
}
