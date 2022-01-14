import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String STORAGE_KEY_TWITTER_USER_TOKEN = "TWITTER_USER_TOKEN";
const String STORAGE_KEY_TWITTER_USER_TOKEN_SECRET =
    "TWITTER_USER_TOKEN_SECRET";
const String STORAGE_KEY_TWITTER_USER_ID = "TWITTER_USER_ID";

class TwitterAuthTokenService {
  saveOnLogin(String token, String tokenSecret, String userId) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "TWITTER_USER_TOKEN", value: token);
    await storage.write(key: "TWITTER_USER_TOKEN_SECRET", value: tokenSecret);
    await storage.write(key: "TWITTER_USER_ID", value: userId);
  }

  Future<bool> isLoggedIn() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: STORAGE_KEY_TWITTER_USER_TOKEN);
    String? tokenSecret =
        await storage.read(key: STORAGE_KEY_TWITTER_USER_TOKEN_SECRET);
    String? userId = await storage.read(key: STORAGE_KEY_TWITTER_USER_ID);

    return token != null && tokenSecret != null && userId != null;
  }

  Future<String?> getTwitterUserId() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: STORAGE_KEY_TWITTER_USER_ID);
    return userId;
  }
}
