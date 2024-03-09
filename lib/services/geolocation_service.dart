abstract interface class GeolocationService {

  Future<void> requestPermission();

  Future<({double latitude, double longitude})> receiveCoordinates();
}
