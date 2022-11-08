
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoadingLogin extends StatelessWidget {
  const LoadingLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),
      builder: (controller) {
        if (controller.isLoading) {
          return Container(
            color: Colors.white70,
            child: ColorLoader5(),
          );
        }
        return Container();
      },
    );
  }
}