import 'package:firebase_database/firebase_database.dart';
import 'package:abigail/common/data/appdata.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  AppData appData = Get.put(AppData());

  List docuid = [];
  RxList uid = [].obs;
  RxList opponentuid = [].obs;
  RxList isopponent = [].obs;

  bool onvalue = false;
  data() async {
    print(onvalue);
    onvalue = false;
    var ref = FirebaseDatabase.instance.ref();
    docuid.clear();
    isopponent.clear();
    opponentuid.clear();
    uid.clear();

    ref.onValue.listen((event) {
      if (uid.isNotEmpty) {
        return;
      }

      Map<String, dynamic>.from(event.snapshot.value as dynamic)
          .forEach((key, value) => {docuid.add(key)});
    });
    await Future.delayed(const Duration(milliseconds: 1000), () {});

    for (int i = 0; i < docuid.length; i++) {
      if (onvalue) {
        return;
      }
      var equalref = ref;

      equalref.onValue.listen((event) async {
        print(onvalue);
        if (onvalue) {
          return;
        }

        if (appData.usermodel.type == "신호수") {
          opponentuid
              .add(event.snapshot.child(docuid[i]).child("planner").value);
          isopponent
              .add(event.snapshot.child(docuid[i]).child("isPlanner").value);
        } else {
          opponentuid
              .add(event.snapshot.child(docuid[i]).child("signaler").value);
          isopponent
              .add(event.snapshot.child(docuid[i]).child("isSignaler").value);
        }
        uid.add(docuid[i]);
      });
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    await Future.delayed(const Duration(milliseconds: 3000), () {});

    onvalue = true;
    super.onInit();
  }
}
