import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const _peerTokenKey = 'peer_token';

  static Future<void> savePeerToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_peerTokenKey, token);
  }

  static Future<String?> getPeerToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_peerTokenKey);
  }

  static Future<void> clearPeerToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_peerTokenKey);
  }
}
