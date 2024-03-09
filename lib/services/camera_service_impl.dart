import 'package:camera/camera.dart';
import 'package:pyshop_test_task/services/camera_service.dart';

class CameraServiceImpl implements CameraService {

  late final CameraController cameraController;

  @override
  Future<void> init() async {
    final cameras = await availableCameras();
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    await cameraController.initialize();
  }

  @override
  Future<XFile> takePhoto() async => await cameraController.takePicture();

  @override
  Future<void> dispose() async => await cameraController.dispose();
}