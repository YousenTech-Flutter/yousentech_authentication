import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_shared_preferences/pos_shared_preferences.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/utils/submit_pin.dart'
    as LoginHelper;

class NumbericItems extends StatefulWidget {
  const NumbericItems(
      {super.key,
      required this.authenticationController,
      required BuildContext contextApp});
  final AuthenticationController authenticationController;
  @override
  State<NumbericItems> createState() => _NumbericItemsState();
}

class _NumbericItemsState extends State<NumbericItems> {
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        spacing: context.setHeight(20),
        children: [
          Row(
            spacing: context.setWidth(14),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "1"),
              itemNumber(data: "2"),
              itemNumber(data: "3"),
            ],
          ),
          Row(
            spacing: context.setWidth(14),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "4"),
              itemNumber(data: "5"),
              itemNumber(data: "6"),
            ],
          ),
          Row(
            spacing: context.setWidth(14),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "7"),
              itemNumber(data: "8"),
              itemNumber(data: "9"),
            ],
          ),
          Row(
            spacing: context.setWidth(14),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "Backspace", iconData: Icons.backspace_rounded),
              itemNumber(data: "0"),
              enterButton(),
            ],
          ),
        ],
      ),
    );
  }

  itemNumber({required dynamic data, IconData? iconData}) {
    counter++;
    return Container(
      width: context.setWidth(95.76),
      height: context.setHeight(66),
      decoration: ShapeDecoration(
        color: SharedPr.isDarkMode!
            ? Colors.white.withValues(alpha: 0.01)
            : const Color(0xFFF6F6F6),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.white.withValues(alpha: 0.50),
          ),
          borderRadius: BorderRadius.circular(context.setMinSize(13)),
        ),
      ),
      child: iconData is IconData
          ? InkWell(
              onTap: () {
                if (data == "Backspace") {
                  widget.authenticationController.setPinKey(
                    isClear: true,
                    data: data,
                  );
                }
                if (data == "Enter") {
                  LoginHelper.subMitPIN(
                    authenticationController: widget.authenticationController,
                  );
                }
              },
              child: Icon(
                iconData,
                color: AppColor.cyanTeal,
                size: context.setWidth(23),
              ),
            )
          // IconButton(
          //   onPressed: () {
          //     if (data == "Backspace") {
          //       widget.authenticationController.setPinKey(
          //         isClear: true,
          //         data: data,
          //       );
          //     }
          //     if (data == "Enter") {
          //       LoginHelper.subMitPIN(
          //         authenticationController: widget.authenticationController,
          //       );
          //     }
          //   },
          //   icon: Icon(
          //     size: context.setWidth(23),
          //     iconData,
          //     color: AppColor.cyanTeal,
          //   ),
          // )
          : InkWell(
              onTap: () {
                widget.authenticationController.setPinKey(data: data);
              },
              child: Center(
                child: Text(
                  data,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SharedPr.isDarkMode!
                        ? Colors.white.withValues(alpha: 0.66)
                        : const Color(0xFF2E2E2E),
                    fontSize: context.setSp(16),
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
    );
  }

  enterButton() {
    return InkWell(
      onTap: () {
        LoginHelper.subMitPIN(
          authenticationController: widget.authenticationController,
        );
      },
      child: Container(
        width: context.setWidth(95.76),
        height: context.setHeight(66),
        decoration: ShapeDecoration(
          color: SharedPr.isDarkMode!
              ? Colors.white.withValues(alpha: 0.01)
              : const Color(0xFFF6F6F6),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.white.withValues(alpha: 0.50),
            ),
            borderRadius: BorderRadius.circular(context.setMinSize(13)),
          ),
        ),
        child: Center(
          child: Text(
            "enter".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: SharedPr.isDarkMode!
                  ? Colors.white.withValues(alpha: 0.66)
                  : const Color(0xFF2E2E2E),
              fontSize: context.setSp(16),
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
