import 'package:abigail/pages/auth/view/login_viewpage.dart';
import 'package:abigail/pages/auth/view/register_viewpage.dart';
import 'package:abigail/pages/main/view/main_view_page.dart';
import 'package:abigail/pages/planner/view/planner_main_view_page.dart';
import 'package:abigail/pages/signaler/view/signaler_main_view_page.dart';
import 'package:abigail/pages/splash/view/splash_view_page.dart';
import 'package:get/get.dart';

class GetXRouter {
  static final route = [
    GetPage(name: '/', page: () => const SplashViewPage()),
    GetPage(name: '/main', page: () => const MainViewPage()),
    GetPage(name: '/login', page: () => const LoginViewPage()),
    GetPage(name: '/register', page: () => const RegisterViewPage()),
    GetPage(name: '/signalermain', page: () => const SignalerMainViewPage()),
    GetPage(name: '/plannermain', page: () => const PlannerMainViewPage()),
  ];
}
