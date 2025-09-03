import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:survey_app/utilities/custom_dialog/SnackBarHelper.dart';

Future<bool> handleCameraPermission(BuildContext context) async {
  PermissionStatus status = await Permission.camera.status;

  if (status.isGranted) {
    return true;
  } else {
    PermissionStatus newStatus = await Permission.camera.request();
    if (newStatus.isGranted) {
      return true;
    } else if (newStatus.isDenied) {
      SnackBarHelper.show(context, 'Camera permission denied');
      return false;
    } else if (newStatus.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return false;
  }
}
