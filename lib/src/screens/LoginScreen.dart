import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:write_only_twitter/src/api/auth/twitter_auth.dart';
import 'package:write_only_twitter/src/api/auth/twitter_auth_result.dart';
import 'package:write_only_twitter/src/api/auth/twitter_login_webview.dart';
import 'package:write_only_twitter/src/service/twitter_auth_token_service.dart';
import 'package:write_only_twitter/src/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    sendToHomeIfLoggedIn();
  }

  sendToHomeIfLoggedIn() async {
    bool isLoggedIn = await TwitterAuthTokenService().isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrimaryTwitterBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Write Only",
                style: TextStyle(
                  color: WhiteText,
                )),
            const Text("Twitter",
                style: TextStyle(
                  color: WhiteText,
                )),
            ElevatedButton(
              onPressed: () async {
                TwitterAuth twitterAuth = TwitterAuth(
                    consumerKey: dotenv.env['TWITTER_API_CONSUMER_KEY']!,
                    consumerSecret:
                        dotenv.env['TWITTER_API_CONSUMER_KEY_SECRET']!);

                TwitterAuthResult result =
                    await twitterAuth.authenticateWithTwitter(
                        context: context,
                        webviewNavigation: _webviewNavigation,
                        onExternalNavigation: launchUrl);

                switch (result.status) {
                  case TwitterAuthStatus.success:
                    TwitterAuthTokenService().saveOnLogin(result.session!.token,
                        result.session!.tokenSecret, result.session!.userId);

                    Navigator.pushNamed(context, '/home');

                    break;
                  case TwitterAuthStatus.failure:
                    break;
                  case TwitterAuthStatus.userCancelled:
                    break;
                }
              },
              child: const Text('Login with Twitter'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Uri?> _webviewNavigation(
    BuildContext context, TwitterLoginWebview webview) async {
  return Navigator.push(
      context,
      MaterialPageRoute<Uri>(
        builder: (_) => Scaffold(
          body: webview,
        ),
        settings: const RouteSettings(name: 'login'),
      ));
}

Future<void> launchUrl(String url) async {
  try {
    await launch(url);
  } catch (e) {
    // Logger.detached('UrlLauncher').warning('cant launch url $url', e);
    // app<MessageService>().show('unable to launch $url');
  }
}
