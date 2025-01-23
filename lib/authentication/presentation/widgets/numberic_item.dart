import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_widgets/config/app_colors.dart';
import 'package:yousentech_authentication/authentication/domain/authentication_viewmodel.dart';
import 'package:yousentech_authentication/authentication/utils/submit_pin.dart';

class NumbericItems extends StatefulWidget {
  const NumbericItems({super.key, required this.authenticationController});
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "1"),
              itemNumber(data: "2"),
              itemNumber(data: "3"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "4"),
              itemNumber(data: "5"),
              itemNumber(data: "6"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "7"),
              itemNumber(data: "8"),
              itemNumber(data: "9"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              itemNumber(data: "Backspace", iconData: Icons.backspace_rounded),
              itemNumber(data: "0"),
              enterButton()
            ],
          ),
        ],
      ),
    );
  }

  itemNumber({required dynamic data, IconData? iconData}) {
    counter++;
    return Container(
      width: 0.05.sw,
      height: 0.05.sh,
      margin: EdgeInsets.symmetric(vertical: 5.r, horizontal: 6.r),
      decoration: BoxDecoration(
          color:
              iconData == null ? AppColor.backgroundTable : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r)),
      child: iconData is IconData
          ? IconButton(
              onPressed: () {
                if (data == "Backspace") {
                  widget.authenticationController
                      .setPinKey(isClear: true, data: data);
                }
                if (data == "Enter") {
                  subMitPIN(
                      authenticationController:
                          widget.authenticationController);
                }
              },
              icon: Icon(
                size: 15.r,
                iconData,
                color: AppColor.cyanTeal,
              ),
            )
          : InkWell(
              // heroTag: "btn$counter",
              // backgroundColor: AppColor.gainsboro,
              onTap: () {
                widget.authenticationController.setPinKey(data: data);
              },
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.gainsboro,
                    borderRadius: BorderRadius.circular(12.r)),
                child: Center(
                  child: Text(
                    data,
                    style: TextStyle(
                        color: AppColor.slateBlue,
                        fontSize: 10.r,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
    );
  }

  enterButton() {
    return InkWell(
      onTap: () {
        subMitPIN(authenticationController: widget.authenticationController);
      },
      child: Container(
        width: 0.05.sw,
        height: 0.05.sh,
        margin: EdgeInsets.symmetric(vertical: 5.r, horizontal: 6.r),
        decoration: BoxDecoration(
            color: AppColor.cyanTeal,
            borderRadius: BorderRadius.circular(12.r)),
        child: Center(
          child: Text(
            "enter".tr,
            style: TextStyle(
                color: AppColor.white,
                fontSize: 8.r,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
