import 'package:flutter/material.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/color.dart';
import '../../../utils/screen_utils.dart';

class WebviewLoader extends StatelessWidget {
  const WebviewLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: colors.white,
        width: ScreenUtils.screenWidth,
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
