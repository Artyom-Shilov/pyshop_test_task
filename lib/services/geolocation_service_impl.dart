import 'package:geolocator/geolocator.dart';
import 'package:pyshop_test_task/services/geolocation_service.dart';

class GeolocationServiceImpl implements GeolocationService {

  @override
  Future<({double latitude, double longitude})> receiveCoordinates() async {
    final position = await Geolocator.getCurrentPosition();
    return (latitude: position.latitude, longitude: position.longitude);
  }

  @override
  Future<void> requestPermission() async => await Geolocator.requestPermission();
}
