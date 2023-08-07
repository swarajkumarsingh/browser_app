import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/snackbar/show_snackbar.dart';

class JhPermissionUtils {
  /// request permission
  static Future<bool> _requestPermission(
      Permission permission, String message) async {
    final status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }
    if (status.isDenied) {
      final PermissionStatus permissionStatus = await permission.request();
      if (permissionStatus.isGranted || permissionStatus.isLimited) {
        return true;
      }
      if (permissionStatus.isPermanentlyDenied || permissionStatus.isDenied) {
        await _showDialog(message);
        return false;
      }
      return false;
    }
    // permanent refusal
    if (status.isPermanentlyDenied) {
      await _showDialog(message);
      return false;
    }

    // iOS14+partial access to album
    // bool isLimited = await permission.isLimited;
    // if (isLimited) {
    //   _showDialog('You have set the app to only access some album resources, please go to the settings to change to all');
    //   return false;
    // }
    return false;
  }

  static Future<void> _showDialog(String message) async {
    Future.delayed(const Duration(milliseconds: 200), () {
      showSnackBar(message);
    });
  }

  /// Album permission check and request
  static Future<bool> photos(
      {String message =
          'There is no permission for the album, please go to the settings to open the permission'}) async {
    Permission permission = Permission.photos;
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo =
          await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        permission = Permission.storage;
      }
    }
    final bool isGranted = await _requestPermission(permission, message);
    return isGranted;
  }

  /// Camera permission check and request
  static Future<bool> camera(
      {String message =
          'No camera permissions yet, please go to settings to enable permissions'}) async {
    final bool isGranted = await _requestPermission(Permission.camera, message);
    return isGranted;
  }

  /// Microphone permission check and request
  static Future<bool> microphone(
      {String message =
          'No microphone permission, please go to settings to enable permission'}) async {
    final bool isGranted =
        await _requestPermission(Permission.microphone, message);
    return isGranted;
  }

  /// Phone storage permission check and request
  static Future<bool> storage(
      {String message =
          'There is no mobile phone storage permission, please go to the settings to open the permission'}) async {
    final bool isGranted =
        await _requestPermission(Permission.storage, message);
    return isGranted;
  }
}

// // camera permissions
// var isGrantedCamera = await Permission.camera.request().isGranted;
// if (!isGrantedCamera) {
//   _showDialog('No camera permissions yet, please go to settings to enable permissions');
//   return;
// }
//
// // microphone permissions
// var isGrantedMicrophone = await Permission.microphone.request().isGranted;
// if (!isGrantedMicrophone) {
//   _showDialog('No microphone permission, please go to settings to enable permission');
//   return;
// }
