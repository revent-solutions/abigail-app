import 'package:abigail/common/data/user_model.dart';
import 'package:get/get.dart';

class AppData extends GetxController {
  String _userEmail = '';

  String get userEmail => _userEmail;

  set userEmail(String userEmail) {
    _userEmail = userEmail;
    update();
  }

  Usermodel _usermodel = Usermodel(
    email: '',
    id: '',
    uid: '',
    name: '',
    type: '',
  );

  Usermodel get usermodel => _usermodel;

  set usermodel(Usermodel usermodel) {
    _usermodel = usermodel;
    update();
  }
}
