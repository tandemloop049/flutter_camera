import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraProvider extends ChangeNotifier {
  bool isCameraAccessGranted = false;
  bool isImageCaptured = false;
  late XFile image;

  // void cameraAccessStatus(bool value) {
  //   isCameraAccessGranted = value;
  //   notifyListeners();
  // }

  void imageCaptureStatus(bool value) {
    isImageCaptured = value;
    notifyListeners();
  }

  void saveImage(XFile value) {
    image = value;
    notifyListeners();
  }
}
