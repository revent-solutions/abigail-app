import 'package:firebase_database/firebase_database.dart';
import 'package:abigail/common/data/appdata.dart';
import 'package:get/get.dart';

class SignalerController extends GetxController {
  AppData appData = Get.put(AppData());
  var ref = FirebaseDatabase.instance.ref(Get.arguments);

  List<RxBool> isSmallButton = [true.obs, false.obs, false.obs];

  List<RxBool> isdirection = [false.obs, false.obs, false.obs, false.obs];

  RxBool isBigButton = false.obs;
  int lastTap = DateTime.now().millisecondsSinceEpoch;
  int consecutiveTaps = 0;
  updates(int index) {
    ref.update({"signal": index});
  }
}
