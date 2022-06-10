
// ignore_for_file: avoid_print

import 'package:gms_mobile/src/resources/userApi.dart';

import '../model/login_model.dart';
import '../resources/session.dart';
import '../state/login_state.dart';
import 'package:get_storage/get_storage.dart';
import '../../helper/getStorage.dart' as constants;

abstract class LoginPresenterAbstract {
  set view(LoginState view) {}
  void loginClicked() {}
}

class LoginPresenter implements LoginPresenterAbstract {
  final LoginModel _loginModel = LoginModel();
  late LoginState _loginState;

  @override
  void loginClicked() {
    _loginModel.isloading = true;
    _loginState.refreshData(_loginModel);
    UserApi.connectToApi(
            _loginModel.username.text.trim(), _loginModel.password.text.trim())
        .then((value) async {
      await GetStorage().write(constants.idUser, value.idUser);
      await GetStorage().write(constants.nik, value.nik);
      await GetStorage().write(constants.idSite, value.idsite);
      await GetStorage().write(constants.namaUser, value.username);
      await GetStorage().write(constants.idPosition, value.idposition);
      print('===' + value.idUser);
      print('==='+value.nik);
      print('===' + value.idsite);
      print('===' + value.username);
      Session.setId(value.idUser);
      Session.setName(value.username);
      Session.setIdSite(value.idsite);
      Session.setIdPosition(value.idposition);
      _loginModel.isloading = false;
      _loginState.refreshData(_loginModel);
      _loginState.onSuccess("yey, Berhasil :D");
    }).catchError((onError) {
      print(onError);
      _loginModel.isloading = false;
      _loginState.refreshData(_loginModel);
      _loginState.onError(onError);
    });
  }

  @override
  set view(LoginState view) {
    // ignore: todo
    // TODO: implement view
    _loginState = view;
    _loginState.refreshData(_loginModel);
  }
}
