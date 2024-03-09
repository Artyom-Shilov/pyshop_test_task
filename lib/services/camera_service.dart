import 'package:camera/camera.dart';

abstract interface class CameraService {

  Future<void> init();
  Future<XFile> takePhoto();
  Future<void> dispose();
}