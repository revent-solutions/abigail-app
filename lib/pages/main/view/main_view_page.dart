import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:abigail/pages/main/controller/main_controller.dart';
import 'package:abigail/pages/planner/controller/planner_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainViewPage extends StatelessWidget {
  const MainViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainController controller = Get.put(MainController());
    return DefaultTextHeightBehavior(
        textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even),
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: const Color(0xFF0089ff),
                  body: Column(
                    children: [
                      information(controller: controller),
                      workSpace(controller)
                    ],
                  )),
            )));
  }
}

Widget information({required MainController controller}) {
  return Padding(
      padding: EdgeInsets.only(top: 76.h),
      child: Row(
        children: [
          Container(
            height: 48.h,
            width: 48.w,
            margin: EdgeInsets.only(left: 24.w, right: 16.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: SvgPicture.asset('assets/icon/profile_icon.svg'),
            ),
          ),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '${controller.appData.usermodel.name}\n',
                    style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                TextSpan(
                    text: controller.appData.usermodel.id,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: 32.w,
            height: 32.h,
            margin: EdgeInsets.only(right: 16.w),
            child: SvgPicture.asset('assets/icon/setting_icon.svg'),
          )
        ],
      ));
}

Widget workSpace(MainController controller) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.only(top: 32.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
        color: Colors.white,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(top: 32.h, left: 24.w, bottom: 8.h),
          child: Text("Workspace",
              style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF18181a),
                  fontWeight: FontWeight.w700)),
        ),
        FutureBuilder(
            future: controller.data(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Obx(() => ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.opponentuid.length,
                    itemBuilder: (context, index) {
                      return workSpaceTile(context, index, controller);
                    },
                  ));
            }),
      ]),
    ),
  );
}

Widget workSpaceTile(
    BuildContext context, int index, MainController controller) {
  PlannerController plannerController = Get.put(PlannerController());

  return Container(
    height: 80.h,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(color: const Color(0xFFe3e6ed), width: 1.w),
      boxShadow: [
        BoxShadow(
            color: const Color.fromRGBO(216, 221, 234, 0.53),
            offset: const Offset(0, 6),
            blurRadius: 20.r)
      ],
    ),
    child: InkWell(
        onTap: () {
          if (controller.isopponent[index]) {
            Get.dialog(modal(
                mainText: "Workspace에\n참여하시겠습니까?",
                numberOfButton: 2,
                button2Text: 'OK',
                button2Function: () async {
                  if (controller.appData.usermodel.type == '플래너') {
                    await plannerController.data(controller.uid[index]);

                    FirebaseDatabase.instance
                        .ref(controller.uid[index])
                        .update({"planner": controller.appData.usermodel.uid});
                    Get.toNamed('/plannermain',
                        arguments: controller.uid[index]);
                  } else {
                    FirebaseDatabase.instance
                        .ref(controller.uid[index])
                        .update({"signaler": controller.appData.usermodel.uid});
                    Get.toNamed('/signalermain',
                        arguments: controller.uid[index]);
                  }
                }));
          } else {
            Get.dialog(modal(
                mainText: "수락 대기중",
                numberOfButton: 1,
                button2Function: () async {
                  await FirebaseDatabase.instance
                      .ref(controller.uid[index])
                      .remove();
                  Get.back();
                }));
          }
        },
        child: Row(
          children: [
            Container(
              height: 48.h,
              width: 48.w,
              margin: EdgeInsets.only(left: 16.w, right: 16.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: SvgPicture.asset('assets/icon/profile_icon.svg'),
              ),
            ),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: 'Workspace ${index + 1}\n',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                  TextSpan(
                      text: '신호수 ${index + 1} • 플래너 ${index + 1}',
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF8a8a8a),
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        )),
  );
}

modal({
  required String mainText,
  int numberOfButton = 2,
  Color button1Color = Colors.white,
  Color button2Color = const Color(0xFF0089ff),
  String button2Text = '요청 취소',
  void Function()? button2Function,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 250.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: const Color(0xFFe3e6ed), width: 1.r),
    ),
    child: IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(top: 54.h),
              child: Text(
                mainText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp),
              )),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, left: 16.w, right: 16.w),
            child: Row(
              children: [
                numberOfButton == 2
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.r),
                                  child: Material(
                                    color: const Color(0xFFc5cacc),
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.h),
                                          child: Center(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.sp),
                                            ),
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.r),
                            child: Material(
                              color: button2Color,
                              child: InkWell(
                                onTap: () {
                                  button2Function!();
                                },
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.h),
                                    child: Center(
                                      child: Text(
                                        button2Text,
                                        style: TextStyle(
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.sp),
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
