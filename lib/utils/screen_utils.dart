import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JhScreenUtils {
  static Future<void> init(BuildContext context) async {
    // If the design draft is designed according to the size of iPhone6(iPhone6 750*1334)
    await ScreenUtil.init(context, designSize: const Size(750, 1334));
  }

  static double setWidth(double width) {
    return ScreenUtil().setWidth(width);
  }

  static double setHeight(double height) {
    return ScreenUtil().setHeight(height);
  }

  static double setSp(num fontSize) {
    return ScreenUtil().setSp(fontSize);
  }

  // static double get screenWidth => ScreenUtil.screenWidth;
  //
  // static double get screenHeight => ScreenUtil.screenHeight;

  // static double get screenWidthPx => ScreenUtil.screenWidthPx;
  //
  // static double get screenHeightPx => ScreenUtil.screenHeightPx;
  //
  // static double get statusBarHeight => ScreenUtil.statusBarHeight;
  //
  // static double get bottomBarHeight => ScreenUtil.bottomBarHeight;

  // 系统方法获取

  static double get screenWidth {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.size.width;
  }

  static bool isNarrow(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return screenSize.width <= 380;
  }

  static double get screenHeight {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.size.height;
  }

  static double get scale {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.devicePixelRatio;
  }

  static double get textScaleFactor {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.textScaleFactor;
  }

  static double get navigationBarHeight {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.padding.top + kToolbarHeight;
  }

  static double get topSafeHeight {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.padding.top;
  }

  static double get bottomSafeHeight {
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
      WidgetsBinding.instance.platformDispatcher.views.single,
    );
    return mediaQuery.padding.bottom;
  }

  static void updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}

/*

ScreenUtil.pixelRatio       // The pixel density of the device
ScreenUtil.screenWidth      // device width
ScreenUtil.screenHeight     // equipment height
ScreenUtil.bottomBarHeight  //Bottom safety zone distance, suitable for buttons under the full screen
ScreenUtil.statusBarHeight  // Status bar height Notch will be higher, unit px
ScreenUtil.textScaleFactory // System font scaling

ScreenUtil.getInstance().scaleWidth  // The ratio of the dp of the actual width to the px of the design draft
ScreenUtil.getInstance().scaleHeight // The ratio of the dp of the actual height to the px of the design draft


width:ScreenUtil().setWidth(100)
height:ScreenUtil().setHeight(80)

Container(
width: 50.w,
height:200.h
)

fontSize: ScreenUtil().setSp(28)

fontSize: ScreenUtil.getInstance().setSp(24),
fontSize: ScreenUtil(allowFontScaling: true).setSp(24),


print('device width:${ScreenUtil.screenWidth}'); //Device width
print('equipment height:${ScreenUtil.screenHeight}'); //Device height
print('The pixel density of the device:${ScreenUtil.pixelRatio}'); //Device pixel density
print('Bottom safety zone distance:${ScreenUtil.bottomBarHeight}'); //Bottom safe zone distance，suitable for buttons with full screen
print('status bar height:${ScreenUtil.statusBarHeight}px');
print('The ratio of the dp of the actual width to the px of the design draft:${ScreenUtil.getInstance().scaleWidth}');
print('The ratio of the dp of the actual height to the px of the design draft:${ScreenUtil.getInstance().scaleHeight}');
print( 'Ratio of width and font size relative to design draft:${ScreenUtil.getInstance().scaleWidth * ScreenUtil.pixelRatio}');
print( 'The ratio of the height relative to the magnification of the design draft:${ScreenUtil.getInstance().scaleHeight * ScreenUtil.pixelRatio}');
print('system font scaling:${ScreenUtil.textScaleFactor}');

*/

/*
    screen width height：MediaQuery.of(context).size.width
    screen width height：MediaQuery.of(context).size.height
    screen status bar height：MediaQueryData.fromWindow(WidgetBinding.instance.window).padding.top。

    MediaQueryData mq = MediaQuery.of(context);
    // screen density
    pixelRatio = mq.devicePixelRatio;
    // Screen width (note that it is dp, converting px requires screenWidth * pixelRatio)
    screenWidth = mq.size.width;
    // Screen height (note that it is dp)
    screenHeight = mq.size.height;
    // The top status bar will increase with the notch
    statusBarHeight = mq padding.top;
    // Bottom function bar, similar to the bottom safety area of ​​iPhone XR
    bottomBarHeight = mq.padding.bottom;

*/
