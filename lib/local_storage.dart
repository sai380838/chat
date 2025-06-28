import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static Future<void> init() async {}

  static Future<void> save(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
