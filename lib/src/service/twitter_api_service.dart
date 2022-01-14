import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:write_only_twitter/src/service/twitter_auth_token_service.dart';

class TwitterApiService {
  Future<TwitterApi?> getClient() async {
    bool _isLoggedIn = await TwitterAuthTokenService().isLoggedIn();
    if (!_isLoggedIn) {
      return null;
    }

    final key = dotenv.env['TWITTER_API_CONSUMER_KEY']!;
    final secret = dotenv.env['TWITTER_API_CONSUMER_KEY_SECRET']!;

    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: STORAGE_KEY_TWITTER_USER_TOKEN);
    String? tokenSecret =
        await storage.read(key: STORAGE_KEY_TWITTER_USER_TOKEN_SECRET);

    if (token == null || tokenSecret == null) {
      return null;
    }

    return TwitterApi(
      client: TwitterClient(
        consumerKey: key,
        consumerSecret: secret,
        token: token,
        secret: tokenSecret,
      ),
    );
  }
}
