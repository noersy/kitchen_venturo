import 'package:kitchen/constans/key_prefens.dart';
import 'package:kitchen/models/userdetail.dart';
import 'package:kitchen/singletons/shared_preferences.dart';
import 'package:logging/logging.dart' as logging;

class UserInstance {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final UserInstance _singleton = UserInstance._internal();
  UserInstance._internal();

  //This is what's used to retrieve the instance through the app
  static UserInstance getInstance() => _singleton;

  static final _log = logging.Logger('UserInstance');

  static UserDetail? _userDetail;

  static final _preferences = Preferences.getInstance();

  //And check the connection status out of the gate
  void initialize({UserDetail? user}) {
    _userDetail = user;
    _getFromPref();
    if (user != null) {
      final _data = user.data;
      _preferences.setStringValue(KeyPrefens.nama, _data.nama ?? '');
      _preferences.setStringValue(KeyPrefens.tgl, "${_data.tglLahir}");
      _preferences.setStringValue(KeyPrefens.tlp, "${_data.telepon}");
      _preferences.setStringValue(KeyPrefens.foto, "${_data.foto}");
      _preferences.setStringValue(KeyPrefens.email, _data.email ?? '');
      _preferences.setStringValue(KeyPrefens.pin, _data.pin ?? '');
      _log.fine("User has initialize");
    }
  }

  void _getFromPref() async {
    if (_userDetail == null) {
      final id = await _preferences.getIntValue(KeyPrefens.loginID);
      final nama = await _preferences.getStringValue(KeyPrefens.nama);
      final tgl = await _preferences.getStringValue(KeyPrefens.tgl);
      final foto = await _preferences.getStringValue(KeyPrefens.foto);
      final tlp = await _preferences.getStringValue(KeyPrefens.tlp);
      final email = await _preferences.getStringValue(KeyPrefens.email);
      final pin = await _preferences.getStringValue(KeyPrefens.pin);

      if (id != -1) {
        final data = UserDetail.fromJson({
          "status_code": 200,
          "data": {
            "id_user": id,
            "nama": nama,
            "email": email,
            "tgl_lahir": tgl,
            "alamat": "",
            "telepon": tlp,
            "foto": foto,
            "ktp": "",
            "pin": pin,
            "status": 0,
            "roles_id": 0,
            "roles": "",
          }
        });

        _userDetail = data;
      }
    }
  }

  UserDetail? get user => _userDetail;
  void clear() {
    _userDetail = null;
  }
}
