import 'package:dio/dio.dart';

import 'network_service.dart';

class NetworkServiceImpl implements NetworkService {

  NetworkServiceImpl() : _dio = Dio() {
    _dio.options = BaseOptions(
        baseUrl: 'https://flutter-sandbox.free.beeceptor.com',
        contentType: 'application/javascript',
        validateStatus: (_) => true);
  }

  final Dio _dio;

  @override
  Future<int?> sendPhoto(
      {required String comment,
      required double latitude,
      required double longitude,
      required String photoPath}) async {
    await MultipartFile.fromFile(photoPath);
    final formData = FormData.fromMap({
      'comment': comment,
      'latitude': latitude,
      'longitude': longitude,
      'photo': await MultipartFile.fromFile(photoPath),
    });
    final response = await _dio.post('/upload_photo', data: formData);
    return response.statusCode;
  }
}