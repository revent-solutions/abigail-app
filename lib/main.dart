import 'dart:async';

import 'package:abigail/firebase_options.dart';
import 'package:abigail/pages/auth/view/login_viewpage.dart';
import 'package:abigail/route/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // 화면 회전 방지 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //플펫폼 강제로 UI 요소를 비활성화 시켜야할때 사용되는 메소드
    statusBarColor: Colors.transparent, //Statusbar 색상을 투명으로 바꿔줌
  ));
  runZonedGuarded(
    //앱 강제 종료시 firebase_crashlytics에 보고
    () {
      runApp(ScreenUtilInit(
        //화면 일정 비율로 설정해주기 위한 클래스
        designSize: const Size(360, 760),
        minTextAdapt: true, //너비와 높이의 최소값에 따라 텍스트를 조정할지 여부
        builder: (context, child) => GetMaterialApp(
            builder: (context, child) {
              return MediaQuery(
                //화면마다 각각 다르게 css를 주는 함수
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!, // child는 null이 아님을 해서 에러 방지 해둠.
              );
            },
            theme: ThemeData(fontFamily: 'Pretendard'),
            //전체 테마 폰트를 설정해뒀음. 변경하고 싶으면 Theme.of().textTheme 사용하면 됨
            debugShowCheckedModeBanner: false,
            //Debug 모양 나오는거 없애기
            locale: Get.deviceLocale,
            //현재 표시할 언어(디바이스) 설정
            defaultTransition: Transition.cupertino,
            home: const LoginViewPage(),
            //home을 실행할때 로딩창으로 띄움
            getPages: GetXRouter.route), // route에 있는 경로들을 get에 넣어준다
      ));
    },
    FirebaseCrashlytics.instance.recordError,
  );
}
