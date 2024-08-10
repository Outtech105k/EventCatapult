/*
 * Config
 * デベロッパーが設定すべき設定ファイル
 * ユーザ向けの設定機能は未実装
 */

class AppConfig {
  static const String appName = 'Event Catapult';
}

class PlacesConfig {
  static const int nameMaxLength = 50;
  static const int descriptionMaxLength = 1000;
}

class RemindsConfig {
  static const int nameMaxLength = 50;
  static const int detailMaxLength = 1000;
}

class FilePathConfig {
  static const String dbFileName = 'db.sqlite';
}
