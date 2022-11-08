import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/views/error.dart';
import 'package:flutter_application_1/views/login/components/background_bottom.dart';
import 'package:flutter_application_1/views/login/components/background_top.dart';
import 'package:get/get.dart';
class GettingStaterView extends StatelessWidget {
  const GettingStaterView({super.key});

  @override
  Widget build(BuildContext context) {
    String router = 'getting_stater_view';
    final LoginController loginController = Get.put(LoginController());
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Error(
            router: router,
            onRefresh: () => loginController.next(),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                const BackgroundTop(),
                const BackgroundBottom(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: GettingStater(router: router),
                ),
                LoadingLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}