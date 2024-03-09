abstract interface class NetworkService {
  Future<int?> sendPhoto(
      {required String comment,
      required double latitude,
      required double longitude,
      required String photoPath});
}