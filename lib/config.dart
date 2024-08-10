/*
 * Config
 * デベロッパーが設定すべき設定ファイル
 * ユーザ向けの設定機能は未実装
 */

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConfig {
  static const String appName = 'Event Catapult';
}

class PlacesConfig {
  static const int nameMaxLength = 50;
  static const int descriptionMaxLength = 1000;
  static const LatLng initPositionWithoutGPS = LatLng(35.6812362, 139.7645445); // Tokyo Sta.
}

class RemindsConfig {
  static const int nameMaxLength = 50;
  static const int detailMaxLength = 1000;
}

class FilePathConfig {
  static const String dbFileName = 'db.sqlite';
}
