import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:shared_widgets/config/theme_controller.dart';
import 'package:shared_widgets/utils/responsive_helpers/device_utils.dart';
import 'package:shared_widgets/utils/responsive_helpers/size_helper_extenstions.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/utils/submit_pin.dart' as LoginHelper;

class NumbericItems extends StatefulWidget {
  const NumbericItems(
      {super.key,
      required this.authenticationController,
      this.fontFamily='Tajawal',
      this.isMobile=false,
      required BuildContext contextApp});
  final AuthenticationController authenticationController;
  final String? fontFamily;
  final bool? isMobile;
  @override
  State<NumbericItems> createState() => _NumbericItemsState();
}

class _NumbericItemsState extends State<NumbericItems> {
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
        double width =  (constraints.maxWidth - (context.setWidth(widget.isMobile! ? 27:14) * 2)) / 3;
        double height =  (constraints.maxHeight - (context.setHeight( widget.isMobile! ? 27: 20) * 3)) / 4;
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            spacing: context.setHeight(widget.isMobile! ? 27: 20),
            children: [
              Row(
                spacing: context.setWidth(widget.isMobile! ? 27: 14),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemNumber(data: "1" , width:width , height: height  ),
                  itemNumber(data: "2", width:width , height: height ),
                  itemNumber(data: "3", width:width , height: height ),
                ],
              ),
              Row(
                spacing: context.setWidth(widget.isMobile! ? 27: 14),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemNumber(data: "4", width:width , height: height ),
                  itemNumber(data: "5", width:width , height: height ),
                  itemNumber(data: "6", width:width , height: height ),
                ],
              ),
              Row(
                spacing: context.setWidth(widget.isMobile! ? 27:14),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemNumber(data: "7", width:width , height: height ),
                  itemNumber(data: "8", width:width , height: height ),
                  itemNumber(data: "9", width:width , height: height ),
                ],
              ),
              Row(
                spacing: context.setWidth(widget.isMobile! ? 27: 14),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemNumber(data: "Backspace", iconData: Icons.backspace_rounded , width:width , height: height ),
                  itemNumber(data: "0" , width:width , height: height ),
                  enterButton(width:width , height: height ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  itemNumber({required dynamic data, IconData? iconData ,double? width , double? height }) {
    counter++;
    return Container(
      width: width ?? context.setWidth(95.76),
      height:height?? context.setHeight(66),
      decoration: ShapeDecoration(
        color: Get.find<ThemeController>().isDarkMode.value ?const Color(0x2B555555): const Color(0xFFF6F6F6) ,
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
                    color: Get.find<ThemeController>().isDarkMode.value?AppColor.white:AppColor.black,
                    fontSize: context.setSp(DeviceUtils.isMobile(context)? 16 : 14),
                    fontFamily:DeviceUtils.isMobile(context)? "SansMedium": 'Tajawal',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
    );
  }

  enterButton({double? width , double? height}) {
    return InkWell(
      onTap: () {
        LoginHelper.subMitPIN(
          authenticationController: widget.authenticationController,
        );
      },
      child: Container(
        width:width ?? context.setWidth(95.76),
        height:height?? context.setHeight(66),
        decoration: ShapeDecoration(
          color: Get.find<ThemeController>().isDarkMode.value ?const Color(0x2B555555): const Color(0xFFF6F6F6) ,
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
              color: Get.find<ThemeController>().isDarkMode.value?AppColor.white:AppColor.black,
              fontSize: context.setSp(14),
              fontFamily:DeviceUtils.isMobile(context)? "SansMedium": 'Tajawal',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
