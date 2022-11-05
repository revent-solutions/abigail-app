import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:abigail/common/data/appdata.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlannerController extends GetxController {
  AppData appData = Get.put(AppData());
  var ref = FirebaseDatabase.instance.ref(Get.arguments);

  List<TextEditingController> textItemList = [];
  TextEditingController item = TextEditingController(text: "Add Task");

  List<RxBool> itemBool = [];
  List<Widget> contents = [];

  contentsData() {
    contents = List.generate(itemBool.length, (index) {
      return Container(
          key: ValueKey(index),
          height: 65.h,
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 2.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r), color: Colors.white),
          width: 360.w,
          child: Obx(
            () => Row(children: [
              Container(
                height: 24.h,
                width: 24.w,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: InkWell(
                  onTap: () {
                    itemBool[index].value = !itemBool[index].value;
                    tasksUpdate();
                  },
                  child: SvgPicture.asset(itemBool[index].value
                      ? 'assets/icon/check.svg'
                      : 'assets/icon/non_check.svg'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 200.w,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 5.h),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: 1,
                  onChanged: ((value) {
                    tasksUpdate();
                  }),
                  controller: textItemList[index],
                  style: TextStyle(
                    decoration: itemBool[index].value
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: itemBool[index].value
                        ? const Color(0xFF555555)
                        : Colors.black,
                    fontFamily: 'Pretendard',
                    fontSize: 16.sp,
                    height: 2.5.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]),
          ));
    }, growable: true);
  }

  deleteItem() {
    for (int i = 0; i < textItemList.length; i++) {
      if (itemBool[i].value) {
        textItemList.removeAt(i);
        itemBool.removeAt(i);
        contents.removeAt(i);
        i--;
      }
    }
    tasksUpdate();
  }

  tasksUpdate() async {
    var Updateref = FirebaseDatabase.instance.ref(Get.arguments);

    List<String> text = [];
    text.clear();
    for (int i = 0; i < textItemList.length; i++) {
      text.add(textItemList[i].text);
    }
    List<bool> bools = [];
    bools.clear();

    Map<int, dynamic> tasks = {};
    Map<int, dynamic> istasks = {};
    tasks.clear();
    for (int i = 0; i < itemBool.length; i++) {
      bools.add(itemBool[i].value);
    }

    for (int i = 0; i < text.toList().length; i++) {
      tasks.addAll({i: text[i]});
      istasks.addAll({i: bools[i]});
    }

    await Updateref.child("tasks").remove();
    await Updateref.child("istasks").remove();

    await Updateref.child("tasks").set(tasks);
    await Updateref.child("istasks").set(istasks);
  }

  data(String uid) async {
    itemBool.clear();
    contents.clear();
    textItemList.clear();
    var refs = FirebaseDatabase.instance.ref(uid);

    refs.child("tasks").onValue.listen((event) {
      if (textItemList.isNotEmpty) {
        return;
      }
      var data = event.snapshot.value as List;

      for (var i in data) {
        textItemList.add(TextEditingController(text: i));
      }
    });

    refs.child("istasks").onValue.listen((event) {
      print(event.snapshot.value);

      if (itemBool.isNotEmpty) {
        return;
      }
      var data = event.snapshot.value as List;

      for (var i in data) {
        itemBool.add(i ? true.obs : false.obs);
      }
    });

    await Future.delayed(const Duration(milliseconds: 1000), () {});
  }

  addItem(int newIndex) {
    itemBool.insert(newIndex, false.obs);
    textItemList.insert(newIndex, TextEditingController(text: item.text));
    contents.insert(
        newIndex,
        Container(
            key: ValueKey(newIndex),
            height: 65.h,
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 2.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r), color: Colors.white),
            width: 360.w,
            child: Obx(
              () => Row(children: [
                Container(
                  height: 24.h,
                  width: 24.w,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: InkWell(
                    onTap: () {
                      itemBool[newIndex].value = !itemBool[newIndex].value;
                      tasksUpdate();
                    },
                    child: SvgPicture.asset(itemBool[newIndex].value
                        ? 'assets/icon/check.svg'
                        : 'assets/icon/non_check.svg'),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 200.w,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 5.h),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    maxLines: 1,
                    controller: textItemList[newIndex],
                    style: TextStyle(
                      decoration: itemBool[newIndex].value
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: itemBool[newIndex].value
                          ? const Color(0xFF555555)
                          : Colors.black,
                      fontFamily: 'Pretendard',
                      fontSize: 16.sp,
                      height: 2.5.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]),
            )));
    item.text = "Add Task";
    tasksUpdate();
  }
}
