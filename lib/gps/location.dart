import 'package:permission_handler/permission_handler.dart';

Future<bool> checkLocationPermissions() async {
  if (!await Permission.location.status.isGranted){
    if (!await Permission.location.request().isGranted){
      return false;
    }
  }

  if (!await Permission.locationAlways.status.isGranted) {
    if (!await Permission.locationAlways.request().isGranted) {
      return false;
    }
  }

  return true;
}
