import 'package:permission_handler/permission_handler.dart';

import '../core/common/snackbar/show_snackbar.dart';

final permissionHandler = _PermissionHandler();

class _PermissionHandler {
  Future<bool> storage() async {
    if (await Permission.storage.isGranted) {
      return true;
    }

    final permissionStatus = await Permission.storage.request();
    if (permissionStatus.isDenied) {
      showSnackBar("Storage permission denied");
      return false;
    }
    if (permissionStatus.isGranted &&
        !permissionStatus.isDenied &&
        !permissionStatus.isPermanentlyDenied) {
      return true;
    }
    if (permissionStatus.isPermanentlyDenied) {
      showSnackBar(
          "There is no mobile phone storage permission, please go to the settings to open the permission");
      return false;
    }
    return false;
  }
}
