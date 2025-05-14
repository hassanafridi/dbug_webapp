import 'package:get/state_manager.dart';
import '../utils/constant.dart';

class AdsCallBackController extends GetxController {
  var dismiss = false.obs;
  var failed = false.obs;

  void setFailed() {
    failed.value = true;
  }

  void setDismiss() {
    dismiss.value = true;
  }

  Future<String> openAdsOnMessageEvent() async {
    if (dismiss.value) {
      return Constant.DISMISS;
    } else {
      return Constant.FAILED;
    }
  }
}
