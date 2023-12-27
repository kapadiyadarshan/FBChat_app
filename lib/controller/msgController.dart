import 'package:get/get.dart';

class MsgController extends GetxController {
  RxBool msgFun = false.obs;
  RxInt msgIndex = 10000000000.obs;

  changeValue({required bool value, required int index}) {
    msgFun(value);
    msgIndex(index);
  }
}
