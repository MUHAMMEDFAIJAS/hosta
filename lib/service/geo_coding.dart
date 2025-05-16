import 'package:geocoding/geocoding.dart';

Future<String> getAddressFromCoordinates(double lat, double lon) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      return '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
  } catch (e) {
    print("Geocoding failed: $e");
  }
  return 'Unknown location';
}
