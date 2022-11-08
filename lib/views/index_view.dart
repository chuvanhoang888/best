
import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/app_preferences.dart';
import 'package:get/get.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State <IndexView> createState() =>  IndexViewState();
}

class  IndexViewState extends State <IndexView> {

  @override
  void initState() {
    super.initState();
    checkEnvironment();
  }

   void checkEnvironment() async {
    await AppPreferences().isPreferenceReady;
    String token = await AppPreferences().getAccessToken();

    if (token != "") {
      Get.toNamed('/admin/appointment');
    } else {
      Get.toNamed('/admin/getting-stater');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
      ),
    );
  }
}

