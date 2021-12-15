// TODO Implement this library.
// const String googleAPIKey = 'AIzaSyDVun1j9vY2WvuWgZ7hLzoPmZgCF1Tsv4I';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';

import 'package:fermata/MVC/models/connection_check.dart';
import 'package:fermata/pages/SearchScreens/SearchScreen.dart';
import 'package:fermata/pages/start_page.dart';
import 'package:fermata/translations/locale_keys.g.dart';

import 'package:fermata/pages/registration.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:fermata/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fermata/Other/static_data.dart';
import 'package:fermata/utils/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:fermata/widgets/btn_widget.dart';
import 'package:fermata/widgets/header_container.dart';
import 'package:ndialog/ndialog.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool checkbox = false;
  var value = "";
  var dbHelper;

  TextEditingController phone_number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController reset_password = TextEditingController();
  TextEditingController confreset_password = TextEditingController();
  TextEditingController Acc_phone_number = TextEditingController();

  TextEditingController answer1 = TextEditingController();
  TextEditingController answer2 = TextEditingController();
  TextEditingController answer3 = TextEditingController();

  ProgressDialog progressDialog;

  SharedPreferences logindata;
  bool newuser;
  String Bilbila="";

  var checkBoxValue;
  var to_send = [];
  var data_copy = [];
  var existed_phonenumber;
  var token;
  var size = 0;

  final String question1 = "childhood Nick Name?";
  final String question2 = "elementary school you attend?";
  final String question3 = "town where you were born?";
  static final String title = 'Has Internet?';

  @override
  void initState() {
    super.initState();
    check_if_already_login();
    //dbHelper = DBHelper_rememberme();
  }


  void  check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      data_tobe_passed.logintype="with_registration";
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => SearchScreen()));
    }else{
      data_tobe_passed.logintype="withOut_registration";
    }

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phone_number.dispose();
    password.dispose();

    super.dispose();
  }

  void showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? 'You have again ${result.toString()}'
        : 'You have no internet';
    final color = hasInternet ? Colors.green : Colors.red;

    Utils.showTopSnackBar(context, message, color);
  }


  Future<bool> _onBackPressed() {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(LocaleKeys.Are_you_sure.tr()),
            content: Text(''),
            actions: <Widget>[
              FlatButton(
                child: Text(LocaleKeys.NO.tr()),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(LocaleKeys.YES.tr()),
                onPressed: () {
                  // Navigator.of(exit(0)).pop(true);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchScreen()));
                },
              ),
            ],
          );
        });
  }

//======================================= ResetPassword =========================================================



  Future ResetPassword(BuildContext context) async {
    var url = Uri.parse(api_host.ip + "/Users/reset_password");
    //data_tobe_passed.phone = phone_number.text;
    var response = await http.post(url, body: {
      "username": existed_phonenumber,
      "password": confreset_password.text,
      "token": token,
    });

    var data = json.decode(response.body);
    print(response.body);
    if (data["header"]["error"] == "false") {
      AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: true,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        btnOkColor: Colors.green,
        title: LocaleKeys.PASSWORD_CHANGED.tr(),
        desc: LocaleKeys.Password_reset_successful.tr(),
        btnOkOnPress: () {},
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        btnOkColor: Colors.red,
        title: LocaleKeys.ERROR.tr(),
        desc: LocaleKeys.unexpected_error.tr(),
        btnOkOnPress: () {},
      ).show();
    }
  }

//======================================= login=========================================================

  Future login(BuildContext context) async {
    var url = Uri.parse(api_host.ip + "/Auth/login");
    var response = await http.post(url, body: {
      "username": phone_number.text,
      "password": password.text,
    });

    var data = json.decode(response.body);
    print(response.body);
    if (data["header"]["error"] == "false") {
      if (data["data"]["role"] == "user") {
        static_loggedin_data.Phone_Number  = data["data"]["username"];
        static_loggedin_data.token = data["data"]["token"];
        print(data["data"]["token"]);
        static_loggedin_data.id = data["data"]["id"];
        static_loggedin_data.role = data["data"]["role"];
//======================================= keep me login =========================================================
        if (checkbox.toString() == "true") {
          String phone = phone_number.text;
          String pass = password.text;
          if (phone != '' && pass != '') {
            print('Successfull');
            logindata.setBool(LocaleKeys.Login.tr(), false);
            logindata.setString(LocaleKeys.Phone_Number.tr(), phone);
            Fluttertoast.showToast(
                msg: LocaleKeys.Login_Successful.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            progressDialog.dismiss();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchScreen()));
            data_tobe_passed.logintype="with_registration";
          } else {
            Fluttertoast.showToast(
                msg: LocaleKeys.caching_error.tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          progressDialog.dismiss();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
          data_tobe_passed.logintype="with_registration";
          //FOR CHECK BOX NOT SELECTED //DO NOT DELETE THI else
        }
// ======================================= keep me login =========================================================
      } else {
        AwesomeDialog(
          context: context,
          useRootNavigator: true,
          headerAnimationLoop: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          btnOkColor: Colors.red,
          title: LocaleKeys.ERROR.tr(),
          desc: LocaleKeys.access_denied.tr(),
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      // AwesomeDialog(
      //   context: context,
      //   useRootNavigator: true,
      //   headerAnimationLoop: true,
      //   dialogType: DialogType.ERROR,
      //   animType: AnimType.BOTTOMSLIDE,
      //   btnOkColor: Colors.red,
      //   title: 'ERROR',
      //   desc: 'invalid username or password!',
      //   btnOkOnPress: () {},
      // ).show();
      progressDialog.dismiss();
      Fluttertoast.showToast(
          msg: LocaleKeys.invalid_username_or_password.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future CheckRecovery(BuildContext context) async {
    to_send = [
      {"id": "", "question": "", "answer": ""},
      {"id": "", "question": "", "answer": ""},
      {"id": "", "question": "", "answer": ""}
    ];
    for (int i = 0; i < size; i++) {
      if (data_copy[i]["question"] == question1) {
        to_send[i]["id"] = data_copy[i]["id"];
        to_send[i]["question"] = data_copy[i]["question"];
        to_send[i]["answer"] = answer1.text;
      } else if (data_copy[i]["question"] == question2) {
        to_send[i]["id"] = data_copy[i]["id"];
        to_send[i]["question"] = data_copy[i]["question"];
        to_send[i]["answer"] = answer2.text;
      } else if (data_copy[i]["question"] == question3) {
        to_send[i]["id"] = data_copy[i]["id"];
        to_send[i]["question"] = data_copy[i]["question"];
        to_send[i]["answer"] = answer3.text;
      }
    }
    var data_tobesent = jsonEncode(to_send);
    var url = Uri.parse(api_host.ip + "/ForgotPassword/check");
    var response = await http.post(url, body: {
      "username": existed_phonenumber,
      "data": data_tobesent,
    });
    var data = json.decode(response.body);

    print(response.body);

    if (data["header"]["error"] == "false") {
      if (data["data"]["status"] == true) {
        token = data["data"]["token"];
        print(token);
        Alert(
            context: context,
            useRootNavigator: false,
            title: LocaleKeys.NEW_Password.tr(),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: reset_password,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: LocaleKeys.Password.tr(),
                  ),
                ),
                TextField(
                  controller: confreset_password,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: LocaleKeys.Confirm_Password.tr(),
                  ),
                ),
              ],
            ),
            buttons: [
              DialogButton(
                color: Colors.orange,
                onPressed: () {
                  Navigator.pop(context);
                  ResetPassword(context);
                },
                child: Text(
                  LocaleKeys.CHANGE.tr(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]).show();
      } else {
        AwesomeDialog(
          context: context,
          useRootNavigator: true,
          headerAnimationLoop: true,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          btnOkColor: Colors.red,
          title: LocaleKeys.Authentication.tr(),
          desc: LocaleKeys.Incorrect_answer.tr(),
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        btnOkColor: Colors.red,
        title: LocaleKeys.ERROR.tr(),
        desc: LocaleKeys.unexpected_error.tr(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  Future Forgot_Password(BuildContext context) async {



    var url = Uri.parse(api_host.ip + "/ForgotPassword/show");
    //data_tobe_passed.phone = phone_number.text;
    var response = await http.post(url, body: {
      "username": Acc_phone_number.text,
      //"token":  "_32049359",
    });

    var data = json.decode(response.body);
    print(response.body);
    if (data["header"]["error"] == "false") {
      size = data["data"].length;
      data_copy = data["data"];
      if (size > 0) {
        existed_phonenumber = Acc_phone_number.text;
        Alert(
            context: context,
            useRootNavigator: false,
            title: LocaleKeys.ACCOUNT_RECOVERY.tr(),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: answer1,
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: question1,
                  ),
                ),
                TextField(
                  controller: answer2,
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: question2,
                  ),
                ),
                TextField(
                  controller: answer3,
                  decoration: InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: question3,
                  ),
                ),
              ],
            ),
            buttons: [
              DialogButton(
                color: Colors.orange,
                onPressed: () {
                  CheckRecovery(context);
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleKeys.SUBMIT.tr(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ]).show();
      } else {
        Fluttertoast.showToast(
            msg: LocaleKeys.Account_not_Found.tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      AwesomeDialog(
        context: context,
        useRootNavigator: true,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        btnOkColor: Colors.red,
        title: LocaleKeys.ERROR.tr(),
        desc: LocaleKeys.unexpected_error.tr(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        // onWillPop: _onBackPressed,
        child: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              Container_with_no_button(LocaleKeys.LOGIN.tr().toString()),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      input_phone_validator(
                          hint: LocaleKeys.Phone_Number.tr().toString(),
                          Icons: Icons.phone,
                          controller: phone_number,
                          keyboardType: TextInputType.phone),
                      inputtxtpassword(
                          hint: LocaleKeys.Password.tr(),
                          Icons: Icons.vpn_key,
                          controller: password),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            LocaleKeys.Remember_me.tr(),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Checkbox(
                            value: checkbox,
                            activeColor: Colors.white,
                            checkColor: Colors.orange,
                            //onChanged: onRememberMeChanged),
                            onChanged: (bool value) {
                              setState(() {
                                this.checkbox = value;
                              });
                            },
                          )
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Alert(
                                  context: context,
                                  useRootNavigator: false,
                                  title: LocaleKeys.ACCOUNT_RECOVERY.tr(),
                                  content: Column(
                                    children: <Widget>[
                                      TextField(
                                        controller: Acc_phone_number,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          icon: Icon(Icons.phone),
                                          focusColor: Colors.orange,
                                          labelText: LocaleKeys.Phone_Number.tr(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      color: Colors.orange,
                                      onPressed: () {

                                        Navigator.of(context).pop();
                                        Forgot_Password(context);


                                      },
                                      child: Text(
                                        LocaleKeys.Next.tr(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    )
                                  ]).show();
                            },
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: LocaleKeys.forgot_password.tr(),
                                    style: TextStyle(color: Colors.deepOrange)),
                              ]),
                            ),
                          )),
                      SizedBox(height: 10),
                      Expanded(
                        child: Center(
                          child: Buttontwo(
                            Icons: Icons.login_outlined,
                            onTab: () {

                              progressDialog = ProgressDialog(context,
                                  message:Text(LocaleKeys.Authentication.tr()),
                                  title:Text(LocaleKeys.Authenticating_Credential.tr())
                              );
                              progressDialog.show();
                              login(context);

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => SearchScreen()));

                            },
                            btnText: LocaleKeys.LOGIN.tr(),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => registration()));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: LocaleKeys.Dont_have_an_Account.tr(),
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: LocaleKeys.Register.tr(),
                                style: TextStyle(color: orangeColors)),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}