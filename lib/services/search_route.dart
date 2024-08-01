import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../secret.dart';

class Polyline{
  Polyline({
    required this.encodedPolyline,
  });

  final String encodedPolyline;

  factory Polyline.fromJson(dynamic json) {
    return Polyline(
        encodedPolyline: json["encodedPolyline"] as String,
    );
  }
}

class Route{
  Route({
    required this.distanceMeters,
    required this.duration,
    required this.polyline,
  });

  final int distanceMeters;
  final String duration;
  final Polyline polyline;

  factory Route.fromJson(dynamic json) {
    return Route(
      distanceMeters: json["distanceMeters"] as int,
      duration: json["duration"] as String,
      polyline: Polyline.fromJson(json["polyline"]),
    );
  }
}

Future<List<Route>> searchDriveRouteFromCurrent(LatLng arrival, DateTime arriveTime) async {

  const url = "https://routes.googleapis.com/directions/v2:computeRoutes";
  final headers = {
    "Content-Type": "application/json",
    "X-Goog-Api-Key": ApiKey.googleMapApiKey,
    "X-Goog-FieldMask": "routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline",
  };

  final location = Location();
  final currentPosition = await location.getLocation();

  final body = jsonEncode({
    "origin": {
      "location": {
        "latLng": {
          "latitude": currentPosition.latitude,
          "longitude": currentPosition.longitude
        }
      }
    },
    "destination": {
      "location": {
        "latLng": {
          "latitude": arrival.latitude,
          "longitude": arrival.longitude
        }
      }
    },
    "arrivalTime": arriveTime.toUtc().toIso8601String(),
    "languageCode": "ja-JP",
    "units": "METRIC"
  });

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    final List<dynamic> routesJson = jsonResponse["routes"];
    return routesJson.map((dynamic json) => Route.fromJson(json)).toList();
  } else {
    return [];
  }
}