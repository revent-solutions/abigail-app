import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:abigail/pages/planner/controller/planner_controller.dart';
import 'package:abigail/pages/signaler/controller/signaler_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class SignalerMainViewPage extends StatelessWidget {
  const SignalerMainViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignalerController controller = Get.put(SignalerController());
    return DefaultTextHeightBehavior(
        textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xFF0089ff),
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 28.h,
              ),
              bigButton(
                svg: 'assets/icon/warning_icon.svg',
                context: context,
                text: "기중기 이상 발생",
                controller: controller,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mediumButton(
                      text: "운전자 호출",
                      vertical: T,
                      svg: 'assets/icon/call_icon.svg',
                      controller: controller,
                      index: 1),
                  mediumButton(
                      svg: 'assets/icon/completion_icon.svg',
                      text: "작업완료",
                      controller: controller,
                      index: 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mediumButton(text: "주권 사용", controller: controller, index: 2),
                  mediumButton(text: "보권 사용", controller: controller, index: 3)
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      mediumButton(
                          text: "뒤집기",
                          notcolor: true,
                          textColor: Colors.white,
                          controller: controller,
                          index: 14),
                      mediumButton(
                          text: "기다리기",
                          notcolor: true,
                          textColor: Colors.white,
                          controller: controller,
                          index: 16,
                          vertical: true),
                      mediumButton(
                          text: "물건 걸기",
                          controller: controller,
                          index: 10,
                          notcolor: true,
                          textColor: Colors.white),
                    ],
                  ),
                  Column(
                    children: [
                      mediumButton(
                          text: "",
                          svg: 'assets/icon/up_icon.svg',
                          notcolor: true,
                          controller: controller,
                          islongTap: T,
                          index: 5),
                      mediumButton(
                          text: "",
                          svg: 'assets/icon/doubleUp_icon.svg',
                          notcolor: true,
                          vertical: true,
                          controller: controller,
                          islongTap: T,
                          index: 6),
                      mediumButton(
                          text: "",
                          svg: 'assets/icon/doubleDown_icon.svg',
                          notcolor: true,
                          controller: controller,
                          islongTap: T,
                          index: 8),
                      mediumButton(
                          text: "",
                          svg: 'assets/icon/down_icon.svg',
                          notcolor: true,
                          vertical: true,
                          controller: controller,
                          islongTap: T,
                          index: 7),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  smallButton(text: "운전방향지시", controller: controller, index: 0),
                  smallButton(text: "수평이동", controller: controller, index: 1),
                  smallButton(text: "천천히 이동", controller: controller, index: 2),
                ],
              ),
              bigButton(
                  svg: 'assets/icon/signal_icon.svg',
                  context: context,
                  text: "신호 보내기",
                  controller: controller,
                  isthreetap: true),
            ],
          )),
        ));
  }
}

Widget bigButton({
  required BuildContext context,
  required String text,
  required SignalerController controller,
  required String svg,
  bool isthreetap = false,
}) {
  return GestureDetector(
    onTap: () {
      if (isthreetap) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if (now - controller.lastTap < 1000) {
          controller.consecutiveTaps++;
          if (controller.consecutiveTaps == 2) {
            controller.updates(12);
          }
        } else {
          controller.isSmallButton[0].value
              ? controller.updates(4)
              : controller.isSmallButton[1].value
                  ? controller.updates(10)
                  : controller.updates(15);

          controller.consecutiveTaps = 0;
        }
        controller.lastTap = now;
      } else {
        controller.updates(18);
      }
    },
    child: Container(
        height: 56.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r), color: Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.h,
              child: SvgPicture.asset(svg),
              margin: EdgeInsets.only(right: 8.w),
            ),
            Text(text,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Pretendard',
                  fontSize: 16.sp,
                  height: 2.5.h,
                  fontWeight: FontWeight.w500,
                ))
          ],
        )),
  );
}

Widget mediumButton(
    {required String text,
    String svg = '',
    bool vertical = false,
    bool notcolor = false,
    bool islongTap = false,
    Color textColor = Colors.black,
    required int index,
    required SignalerController controller}) {
  return GestureDetector(
    onLongPress: () {
      if (islongTap) {
        controller.updates(index);
      }
    },
    onLongPressEnd: (details) {
      if (islongTap) {
        controller.updates(0);
      }
    },
    onTap: () {
      if (!islongTap) {
        controller.updates(index);
      }
    },
    child: Container(
        width: 152.w,
        height: 56.h,
        margin:
            EdgeInsets.symmetric(horizontal: 4.w, vertical: vertical ? 8.h : 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
                width: notcolor ? 1.w : 0,
                color: const Color.fromRGBO(255, 255, 255, 0.56)),
            color: notcolor ? const Color(0xFF005cab) : Colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            svg != ''
                ? Container(
                    width: 20.w,
                    height: 20.h,
                    margin: EdgeInsets.only(right: 5.w),
                    child: SvgPicture.asset(svg),
                  )
                : const SizedBox(),
            Text(text,
                style: TextStyle(
                  color: textColor,
                  fontFamily: 'Pretendard',
                  fontSize: 16.sp,
                  height: 2.5.h,
                  fontWeight: FontWeight.w500,
                ))
          ],
        )),
  );
}

Widget smallButton(
    {required String text,
    required SignalerController controller,
    required int index}) {
  return Obx(() => Container(
        width: 98.w,
        height: 56.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
            border: Border.all(
                width: controller.isSmallButton[index].value ? 0 : 1.w,
                color: const Color.fromRGBO(255, 255, 255, 0.56)),
            borderRadius: BorderRadius.circular(4.r),
            color: controller.isSmallButton[index].value
                ? Colors.white
                : const Color(0xFFc5cacc)),
        child: InkWell(
            onTap: () {
              controller.isSmallButton[0].value = false;
              controller.isSmallButton[1].value = false;
              controller.isSmallButton[2].value = false;
              controller.isSmallButton[index].value = true;
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  child: SvgPicture.asset(
                    'assets/icon/check_icon.svg',
                    color: controller.isSmallButton[index].value
                        ? Color(0xFF0089ff)
                        : Colors.white,
                  ),
                ),
                Text(text,
                    style: TextStyle(
                      color: controller.isSmallButton[index].value
                          ? Colors.black
                          : Colors.white,
                      fontFamily: 'Pretendard',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ))
              ],
            )),
      ));
}
