
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/error_controller.dart';
import 'package:flutter_application_1/views/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Error extends StatelessWidget {
  final Widget child;
  final String router;
  final Function onRefresh;
  const Error({super.key, required this.child, required this.router, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    ErrorController errorController = Get.put(ErrorController());
    return GetBuilder<ErrorController>(
      init: errorController,
      builder: (controller) {
        if (controller.showError && controller.router == router) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (controller.isDialogOpen)
                  const Responsive(
                    mobile:  SizedBox(height: 80),
                    tablet: SizedBox(height: 90),
                    web:  SizedBox(height: 112),
                  ),
                Text('404',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color:const Color(0xFF2F2C35))),
                Text('Oops, something went wrong',
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: const Color(0xFF2F2C35), fontWeight: FontWeight.w500)),
                Center(child: SvgPicture.asset('assets/images/gears.svg')),
                SizedBox(height: Responsive.isMobile(context) ? 30 : 35),
                GestureDetector(
                  onTap: () {
                    controller.setShowError(false);
                    onRefresh();
                  },
                  child: Text('Try refreshing the app',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(color: const Color(0xFF605D73))),
                ),
              ],
            ),
          );
        }
        return child;
      },
    );
  }
}