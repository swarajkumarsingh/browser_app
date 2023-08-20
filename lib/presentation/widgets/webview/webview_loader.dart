import 'package:flutter/material.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color.dart';
import '../../../utils/screen_utils.dart';

class WebviewLoader extends StatelessWidget {
  final double bottomNavigationBarHeight;
  const WebviewLoader({
    super.key, required this.bottomNavigationBarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: colors.white,
        width: ScreenUtils.screenHeight - bottomNavigationBarHeight,
        height: ScreenUtils.screenHeight,
        child: Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(assets.transparentLogo),
          ),
        ),
      ),
    );
  }
}
