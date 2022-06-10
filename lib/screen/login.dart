// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gms_mobile/helper/getStorage.dart';
import 'package:gms_mobile/src/model/login_model.dart';
import 'package:gms_mobile/src/presenter/login_presenter.dart';
import 'package:gms_mobile/src/resources/session.dart';
import 'package:gms_mobile/src/state/login_state.dart';

import 'fragment/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginUI createState() => _LoginUI();
}

class _LoginUI extends State<Login> implements LoginState {
  late LoginPresenter _loginPresenter;
  // ignore: unused_field
  late LoginModel _loginModel;
  bool _isPasswordVisible = true; 
  final _formkey = GlobalKey<FormState>();
  _LoginUI() {
    _loginPresenter = LoginPresenter();

    Session.checkUser().then((check) {
      if (check) {
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loginPresenter.view = this;
    _isPasswordVisible = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loginModel.isloading
          ? const Loading()
          : SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                child: Form(
                  key: _formkey,
                  child: Container(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'hero',
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 48.0,
                            child: Image.asset('assets/img/alogo.png'),
                          ),
                        ),
                        Text("Masuk",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 34,
                                  color: Color(0xff212121),
                                  fontWeight: FontWeight.bold),
                            )),
                        Text("Silahkan Login",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 12, color: Color(0xff383838)),
                            )),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 30,
                                margin: const EdgeInsets.only(
                                    top: 4, left: 16, bottom: 1, right: 16),
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Color(0xff2D8EFF)),
                                    )),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      setState(() {
                                        _loginModel.isErrorUsername = true;
                                        _loginModel.usernameError =
                                            "Username tidak boleh kosong";
                                      });
                                    }
                                    return null;
                                  },
                                  onChanged: (str) {
                                    setState(() {
                                      _loginModel.isErrorUsername = false;
                                      _loginModel.usernameError = "";
                                    });
                                  },
                                  controller: _loginModel.username,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.account_box_outlined,
                                        color: _loginModel.isErrorUsername
                                            ? Colors.red
                                            : const Color(0xff2D8EFF),
                                        size: 18,
                                      ),
                                      hintText: "Username",
                                      border: InputBorder.none,
                                      errorText: _loginModel.usernameError,
                                      errorStyle: const TextStyle(
                                          color: Colors.red, fontSize: 9),
                                      fillColor: Colors.grey,
                                      hintStyle: const TextStyle(
                                          color: Color(0xff2D8EFF),
                                          fontSize: 12)),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 30,
                                margin: const EdgeInsets.only(
                                    top: 4, left: 16, bottom: 1, right: 16),
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Color(0xff2D8EFF)),
                                    )),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null) {
                                      setState(() {
                                        _loginModel.isErrorPassword = true;
                                        _loginModel.passwordError =
                                            "Password tidak boleh kosong";
                                      });
                                    }
                                    return null;
                                  },
                                  onChanged: (str) {
                                    setState(() {
                                      _loginModel.isErrorPassword = false;
                                      _loginModel.passwordError = "";
                                    });
                                  },
                                  controller: _loginModel.password,
                                  obscureText: _isPasswordVisible,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.lock,
                                        color: _loginModel.isErrorPassword
                                            ? Colors.red
                                            : const Color(0xff2D8EFF),
                                        size: 18,
                                      ),
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          }),
                                      hintText: "Password",
                                      border: InputBorder.none,
                                      errorText: _loginModel.passwordError,
                                      errorStyle: const TextStyle(
                                          color: Colors.red, fontSize: 9),
                                      fillColor: Colors.grey,
                                      hintStyle: const TextStyle(
                                          color: Color(0xff2D8EFF),
                                          fontSize: 12)),
                                ),
                              ),
                              InkWell(
                                splashColor: const Color(0xff7474BF),
                                onTap: () async {
                                  if (_formkey.currentState!.validate()) {
                                    _loginPresenter.loginClicked();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 50.0),
                                  height: 43,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0, 28),
                                            blurRadius: 40,
                                            spreadRadius: -12)
                                      ],
                                      color: Color(0xff1d63dc),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Center(
                                    child: Text(
                                      "Masuk",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void onError(String error) {
    print(error);
  }

  @override
  void onSuccess(String success) {
    print(GetStorage().read(nik));
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  void refreshData(LoginModel loginModel) {
    setState(() {
      _loginModel = loginModel;
    });
  }

  @override
  void onMuridOff(String alert) {}
}
