import 'package:abigail/common/utils/helper/email_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:abigail/pages/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class RegisterViewPage extends StatelessWidget {
  const RegisterViewPage({Key? key}) : super(key: key);

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
                      textInput(
                          authController: controller,
                          controller: controller.id,
                          text: "이메일을 입력해주세요."),
                      SizedBox(
                        height: 16.h,
                      ),
                      textInput(
                          authController: controller,
                          controller: controller.name,
                          text: "이름을 입력해주세요."),
                      SizedBox(
                        height: 8.h,
                      ),
                      passwordInput(controller: controller, number: 0),
                      Obx(() => controller.isPasswordCheck[0].value
                          ? errorText()
                          : const SizedBox()),
                      passwordInput(controller: controller, number: 1),
                      Obx(() => controller.isPasswordCheck[1].value
                          ? errorText()
                          : const SizedBox()),
                      registerButton(context: context, controller: controller),
                      loginButton(controller),
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
          "비밀번호를 확인해주세요.",
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

Widget textInput(
    {required AuthController authController,
    required TextEditingController controller,
    required String text}) {
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
              controller: controller,
              cursorColor: Colors.purple,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                if (authController.id.text.isNotEmpty &&
                    authController.password[0].text.isNotEmpty &&
                    authController.password[1].text.isNotEmpty &&
                    !authController.isPasswordCheck[0].value &&
                    !authController.isPasswordCheck[1].value &&
                    authController.name.text.isNotEmpty &&
                    EmailFormatHelper.isEmailValid(authController.id.text)) {
                  authController.isEmpty[1].value = true;
                } else {
                  authController.isEmpty[1].value = false;
                }
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: text,
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

Widget registerButton(
    {required BuildContext context, required AuthController controller}) {
  return InkWell(
      onTap: () {
        if (controller.isEmpty[1].value) {
          controller.registerFirebase();
        }
      },
      child: Obx(() => Container(
            width: MediaQuery.of(context).size.width,
            height: 48.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: controller.isEmpty[1].value
                    ? const Color(0xFF0089ff)
                    : const Color(0xFFc5cacc)),
            margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
            child: Center(
                child: Text(
              "회원가입",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            )),
          )));
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
                  controller.isPasswordCheck[0].value = false;
                  controller.isPasswordCheck[1].value = false;

                  if (controller.id.text.isNotEmpty &&
                      controller.password[0].text.isNotEmpty &&
                      controller.password[1].text.isNotEmpty &&
                      !controller.isPasswordCheck[0].value &&
                      !controller.isPasswordCheck[1].value &&
                      EmailFormatHelper.isEmailValid(controller.id.text)) {
                    controller.isEmpty[1].value = true;
                  } else {
                    controller.isEmpty[1].value = false;
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        number == 1 ? '비밀번호를 다시한번 입력해주세요.' : '비밀번호를 입력해주세요.',
                    hintStyle: TextStyle(
                      color: const Color(0xFF9d9d9d),
                      fontFamily: 'Pretendard',
                      letterSpacing: -0.47.sp,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                    )),
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
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

Widget loginButton(AuthController controller) {
  return InkWell(
    onTap: () {
      controller.id.text = '';
      controller.password[0].text = '';
      controller.password[1].text = '';
      Get.offAllNamed('/login');
    },
    child: Center(
        child: Text(
      "로그인",
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF808080),
        decoration: TextDecoration.underline,
      ),
    )),
  );
}
