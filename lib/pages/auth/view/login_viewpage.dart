import 'package:abigail/common/utils/helper/email_format_helper.dart';
import 'package:abigail/pages/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

class LoginViewPage extends StatelessWidget {
  const LoginViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    return DefaultTextHeightBehavior(
        textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even),
        child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SafeArea(
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      text(),
                      _tabBar(context: context, controller: controller),
                      textInput(controller: controller),
                      passwordInput(controller: controller, number: 0),
                      Obx(() => controller.isPasswordCheck[0].value
                          ? errorText()
                          : const SizedBox()),
                      loginButton(context: context, controller: controller),
                      registerButton(controller),
                    ],
                  )),
            )));
  }
}

Widget errorText() {
  return Padding(
      padding: EdgeInsets.only(left: 28.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "비밀번호를 입력해주세요.",
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.33.sp,
              color: const Color(0xFFf63232)),
        ),
      ));
}

Widget text() {
  return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Text(
        "ABIGAIL",
        style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2e4670)),
      ));
}

Widget textInput({required AuthController controller}) {
  return Container(
      height: 44.h,
      width: 324.w,
      decoration: BoxDecoration(
          color: const Color(0xFFd8d8d8).withOpacity(0.26),
          borderRadius: BorderRadius.circular(8.r)),
      margin: EdgeInsets.symmetric(horizontal: 28.w),
      child: Row(textBaseline: TextBaseline.alphabetic, children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 28.w,
          height: 28.h,
          child: Center(
            child: SvgPicture.asset('assets/icon/id_icon.svg'),
          ),
        ),
        SizedBox(
          height: 44.h,
          width: 218.w,
          child: TextField(
              onChanged: (value) {
                if (controller.password[0].text.isNotEmpty &&
                    controller.id.text.isNotEmpty &&
                    EmailFormatHelper.isEmailValid(controller.id.text)) {
                  controller.isEmpty[0].value = true;
                } else {
                  controller.isEmpty[0].value = false;
                }
              },
              controller: controller.id,
              cursorColor: Colors.purple,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '이메일을 입력해주세요.',
                  hintStyle: TextStyle(
                    color: const Color(0xFF9d9d9d),
                    fontFamily: 'Pretendard',
                    letterSpacing: -0.47.sp,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  )),
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16.sp,
                letterSpacing: -0.47.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ),
      ]));
}

Widget loginButton(
    {required BuildContext context, required AuthController controller}) {
  return GestureDetector(
      onTap: () {
        if (controller.isEmpty[0].value) {
          controller.loginFirebase();
        } else {}
      },
      child: Obx(() => Container(
            width: MediaQuery.of(context).size.width,
            height: 48.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: controller.isEmpty[0].value
                    ? const Color(0xFF0089ff)
                    : const Color(0xFFc5cacc)),
            margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
            child: Center(
                child: Text(
              "로그인",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            )),
          )));
}

Widget registerButton(AuthController controller) {
  return InkWell(
    onTap: () {
      controller.id.text = '';
      controller.name.text = '';
      controller.password[0].text = '';
      controller.password[1].text = '';

      Get.offAllNamed('/register');
    },
    child: Center(
        child: Text(
      "회원가입",
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF808080),
        decoration: TextDecoration.underline,
      ),
    )),
  );
}

Widget passwordInput(
    {required AuthController controller, required int number}) {
  return Obx(() => Container(
        height: 44.h,
        width: 324.w,
        decoration: BoxDecoration(
            color: controller.isPasswordCheck[0].value
                ? const Color.fromRGBO(246, 50, 50, 0.07)
                : const Color(0xFFd8d8d8).withOpacity(0.26),
            borderRadius: BorderRadius.circular(8.r),
            border: controller.isPasswordCheck[0].value
                ? Border.all(color: const Color(0xFFf63232), width: 0.7.w)
                : null),
        margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 8.h),
        child: Row(textBaseline: TextBaseline.alphabetic, children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            width: 28.w,
            height: 28.h,
            child: Center(
              child: SvgPicture.asset('assets/icon/passwd_icon.svg'),
            ),
          ),
          SizedBox(
            height: 44.h,
            width: 218.w,
            child: TextField(
                obscureText: true,
                obscuringCharacter: "●",
                controller: controller.password[number],
                cursorColor: Colors.purple,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  controller.isPasswordCheck[number].value = false;

                  if (controller.password[0].text.isNotEmpty &&
                      controller.id.text.isNotEmpty &&
                      EmailFormatHelper.isEmailValid(controller.id.text)) {
                    controller.isEmpty[0].value = true;
                  } else {
                    controller.isEmpty[0].value = false;
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '비밀번호를 입력해주세요.',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9d9d9d),
                      fontFamily: 'Pretendard',
                      letterSpacing: -0.47.sp,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    )),
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16.sp,
                  letterSpacing: 3.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                )),
          ),
        ]),
      ));
}

Widget _tabBar(
    {required AuthController controller, required BuildContext context}) {
  return Padding(
    padding: EdgeInsets.only(left: 28.w, right: 28.w, top: 48.h, bottom: 40.h),
    child: Column(children: [
      IntrinsicHeight(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 44.h,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF0F0F8), width: 1.w),
              boxShadow: [
                BoxShadow(
                    color: const Color.fromRGBO(216, 221, 234, 0.53),
                    offset: const Offset(0, 6),
                    blurRadius: 20.r)
              ],
              borderRadius: BorderRadius.circular(22.r),
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TabBar(
                  onTap: ((value) {
                    if (value == 0) {
                      controller.type = '신호수';
                    } else {
                      controller.type = '플래너';
                    }
                  }),
                  indicator: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFFe3e6ed), width: 1.r),
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xFF0089ff),
                  ),
                  labelColor: Colors.white,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  controller: controller.plannerTab,
                  indicatorColor: const Color(0xFFE4E3F3),
                  unselectedLabelColor: const Color(0xff9d9d9d),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  tabs: const [
                    Tab(child: Text('신호수')),
                    Tab(child: Text('플래너')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]),
  );
}
