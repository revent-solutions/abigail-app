import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:abigail/pages/planner/controller/planner_controller.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';

class PlannerMainViewPage extends StatefulWidget {
  const PlannerMainViewPage({Key? key}) : super(key: key);

  @override
  State<PlannerMainViewPage> createState() => _PlannerMainViewPage();
}

class _PlannerMainViewPage extends State<PlannerMainViewPage> {
  @override
  Widget build(BuildContext context) {
    PlannerController controller = Get.put(PlannerController());

    reoder(oldIndex, newIndex) {
      setState(() {
        var row = controller.contents.removeAt(oldIndex);
        controller.contents.insert(newIndex, row);
        var itemrow = controller.textItemList.removeAt(oldIndex);
        controller.textItemList.insert(newIndex, itemrow);
        var bool = controller.itemBool.removeAt(oldIndex);
        controller.itemBool.insert(newIndex, bool);
      });
      controller.tasksUpdate();
    }

    itemAdd(int newIndex) {
      setState(() {
        controller.addItem(newIndex);
      });
    }

    addButton(
        {required BuildContext context,
        required String text,
        required PlannerController controller}) {
      return Container(
          height: 56.h,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                  width: 1.w, color: const Color.fromRGBO(255, 255, 255, 0.56)),
              color: const Color(0xFF005cab)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  itemAdd(controller.contents.length);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  width: 20.w,
                  height: 20.h,
                  child: SvgPicture.asset('assets/icon/plus_icon.svg'),
                ),
              ),
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    maxLines: 1,
                    controller: controller.item,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                      fontSize: 16.sp,
                      height: 2.5.h,
                      fontWeight: FontWeight.w500,
                    )),
              )
            ],
          ));
    }

    deleteButton({required PlannerController controller}) {
      return Align(
          alignment: Alignment.centerLeft,
          child: Container(
              width: 32.w,
              height: 32.h,
              margin: EdgeInsets.only(left: 24.w, top: 12.h, bottom: 100.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                      width: 1.w,
                      color: const Color.fromRGBO(255, 255, 255, 0.56)),
                  color: const Color(0xFF005cab)),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      controller.deleteItem();
                    });
                  },
                  child: Center(
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      child: SvgPicture.asset('assets/icon/minus_icon.svg'),
                    ),
                  ))));
    }

    controller.contentsData();
    return DefaultTextHeightBehavior(
        textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even),
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: const Color(0xFF0089ff),
                automaticallyImplyLeading: false,
                title: Text("플래닝",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 20.sp,
                    )),
                leading: InkWell(
                    onTap: () {
                      Get.offAllNamed("/main");
                    },
                    child: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Icon(
                            const IconData(
                              0xe092,
                              fontFamily: 'MaterialIcons',
                              matchTextDirection: true,
                            ),
                            size: 30.h,
                            color: Colors.white))),
              ),
              resizeToAvoidBottomInset: true,
              backgroundColor: const Color(0xFF0089ff),
              body: Column(
                children: [
                  Expanded(
                      child: ReorderableColumn(
                    onReorder: reoder,
                    children: controller.contents,
                  )),
                  deleteButton(controller: controller),
                  addButton(
                      context: context,
                      text: "Add Task",
                      controller: controller)
                ],
              )),
        ));
  }
}
