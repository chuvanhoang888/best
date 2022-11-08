
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundBottom extends StatelessWidget {
  const BackgroundBottom({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomRight,
      child: Responsive(
        mobile: Container(),
        tablet: SvgPicture.asset(
          'assets/images/background_bottom.svg',
          width: size.width * 0.7,
        ),
        web: SvgPicture.asset(
          'assets/images/background_bottom.svg',
          width: size.width * 0.4,
        ),
      ),
    );
  }
}