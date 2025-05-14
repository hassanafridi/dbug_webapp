import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../screen/no_internet.dart';
class NetworkController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      _checkConnection();
    });
    Connectivity().onConnectivityChanged.listen((_) {
      _checkConnection();
    });
  }

  Future<void> _checkConnection() async {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    if (!hasInternet && isConnected.value) {
      isConnected.value = false;
      Get.to(
        () => NoInternet(/*onRetry: _retryConnection*/),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 200),
      );
    } else if (hasInternet && !isConnected.value) {
      isConnected.value = true;
      Get.back();
    }
  }

  void _retryConnection() async {
    _checkConnection();
  }
}
