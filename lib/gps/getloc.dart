import 'package:location/location.dart';

class GetLocation {
  static Future<LocationData> getPosition(Location location) async {
    final currentLocation = await location.getLocation();
    return currentLocation;
  }
}
