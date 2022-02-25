import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart' as logging;

class GoogleLogin {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final GoogleLogin _singleton = GoogleLogin._internal();

  GoogleLogin._internal();

  static final _log = logging.Logger('GoogleAuth');


  //This is what's used to retrieve the instance through the app
  static GoogleLogin getInstance() => _singleton;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<GoogleSignInAccount?> login() async {
    try {
      return await _googleSignIn.signIn();
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }
    return null;
  }

  Future<GoogleSignInAccount?> logout() async {
    try {
      return await _googleSignIn.signOut();
    } catch (e, r) {
      _log.warning(e);
      _log.warning(r);
    }
    return null;
  }
}
