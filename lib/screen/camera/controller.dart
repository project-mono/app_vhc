import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreenController {
  final cameras = ValueNotifier(const <CameraDescription>[]);
  final selectedCamera = ValueNotifier<CameraDescription?>(null);

  /// true = all grant, false = once reject, null = permanently reject
  Future<bool?> requestPermissions() async {
    const permission = Permission.camera;
    if (await permission.isPermanentlyDenied) {
      return null;
    } else {
      return permission.request().then((rsp) => rsp.isGranted);
    }
  }

  Future<void> loadCameras() async {
    cameras.value = await availableCameras();
    selectedCamera.value ??= cameras.value.firstOrNull;
  }

  dispose() {
    cameras.dispose();
    selectedCamera.dispose();
  }
}
