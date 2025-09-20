import 'package:geolocator/geolocator.dart';

class LocationCache {
  static double? _latitude;
  static double? _longitude;
  static DateTime? _lastUpdated;

  static Future<void> init() async {
    if (_lastUpdated == null ||
        DateTime.now().difference(_lastUpdated!) > const Duration(minutes: 5)) {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );
      _latitude = pos.latitude;
      _longitude = pos.longitude;
      _lastUpdated = DateTime.now();
    }
  }

  static double? get lat => _latitude;
  static double? get lng => _longitude;

}
