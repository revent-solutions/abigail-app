import 'package:flutter/material.dart';
import 'package:abigail/common/data/appdata.dart';
import 'package:abigail/common/data/user_model.dart';
import 'package:abigail/common/utils/helper/email_format_helper.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController with GetTickerProviderStateMixin {
  TabController? plannerTab;
  AppData appData = Get.put(AppData());
  String type = '신호수';

  RxList<TextEditingController> password =
      [TextEditingController(), TextEditingController()].obs;
  TextEditingController id = TextEditingController();
  TextEditingController name = TextEditingController();
  List<RxBool> isPasswordCheck = [false.obs, false.obs];

  List<RxBool> isEmpty = [false.obs, false.obs];

  RxBool loginButton() {
    if (isPasswordCheck[0].value) {
      return false.obs;
    }
    if (id.text.isNotEmpty &&
        password[0].text.isNotEmpty &&
        EmailFormatHelper.isEmailValid(id.text)) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  RxBool registerButton() {
    if (id.text.isNotEmpty &&
        password[0].text.isNotEmpty &&
        password[1].text.isNotEmpty &&
        !isPasswordCheck[0].value &&
        !isPasswordCheck[1].value &&
        EmailFormatHelper.isEmailValid(id.text)) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  loginFirebase() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: id.text, password: password[0].text);

      await updateAppData(email: id.text);
      Get.offAllNamed("/main");
    } on FirebaseAuthException {
      isPasswordCheck[0].value = false;
      Get.snackbar('로그인 실패', '이메일,비밀번호를 다시한번 확인해주세요.');
    }
  }

  registerFirebase() async {
    if (password[0].text != password[1].text) {
      isPasswordCheck[0].value = isPasswordCheck[1].value = true;

      Get.snackbar('회원가입 에러', '비밀번호가 서로 일치하지 않습니다.');

      return 0;
    }
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: id.text, password: password[0].text);

      final firebaseInstance = FirebaseFirestore.instance;
      final CollectionReference userCollection =
          firebaseInstance.collection("users");
      String uid = FirebaseAuth.instance.currentUser!.uid;

      await userCollection.doc(uid).set({
        "uid": uid,
        "name": name.text,
        "email": id.text,
        "id": id.text,
        'type': type,
      });
      id.text = '';
      password[0].text = '';
      password[1].text = '';
      Get.toNamed("/login");
    } catch (e) {
      Get.snackbar('에러', e.toString());
    }
  }

  @override
  void onInit() {
    plannerTab = TabController(initialIndex: 0, length: 2, vsync: this);

    super.onInit();
  }

  Future<void> updateAppData({required String email}) async {
    AppData appData = Get.find();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      appData.usermodel = Usermodel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
  }
}
