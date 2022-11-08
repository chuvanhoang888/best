import 'package:get/get.dart';

class ErrorController extends GetxController{
  bool showError = false;
  String router = '';
  bool isDialogOpen = false;

  void setShowError(bool value) {
    showError = value;
    update();
  }

  void setRouter(String value) {
    showError = false;
    router = value;
    update();
  }

  void setDialogOpen(bool value) {
    isDialogOpen = value;
    update();
  }

  @override
  void onInit() {
    showError = false;
    isDialogOpen = false;
    router = '';
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}