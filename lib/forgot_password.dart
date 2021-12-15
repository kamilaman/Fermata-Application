import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fermata/utils/color.dart';
import 'package:fermata/widgets/btn_widget.dart';
import 'package:fermata/Other/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fermata/pages/signup_page.dart';


import 'login_page.dart';


class Forgot_Password extends StatefulWidget {


  @override
  Forgot_PasswordState createState() => Forgot_PasswordState();
}


class Forgot_PasswordState extends State<Forgot_Password> {



  final String question1= "What is your childhood Nick Name";
  final String question2= "What elementary school did you attend?";
  final String question3= "What is the name of the town where you were born?";

  TextEditingController answer1 = TextEditingController();
  TextEditingController answer2 = TextEditingController();
  TextEditingController answer3 = TextEditingController();

  String userphone = signUp_pageState().phone_number.text.toString();


  Future forgotpass_register() async {



    var url = Uri.parse(api_host.ip+"/ForgotPassword/save");

    var send=[
      {
        "answer": answer1.text,
        "question": question1

      },
      {
        "answer": answer2.text,
        "question": question2

      },
      {
        "answer": answer3.text,
        "question": question3
      }
    ];

    var value = jsonEncode(send);
    var response = await http.post(url, body: {
      "data": value,
      "username": data_tobe_passed.phone
    });

    var data = json.decode(response.body);
    print(response.body);
    if (data["header"]["error"]=="true") {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'ERROR',
        desc: 'Access Denied!',
        btnOkOnPress: () {

        },
      ).show();
    } else {
      AwesomeDialog(
        context: context,
        headerAnimationLoop: true,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'REGISTRATION SECCESS',
        desc: 'Registration Successful!',

        btnOkOnPress: () {

        },
      ).show();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        //onWillPop: _onBackPressed,
        child: Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              //HeaderContainer("Register"),
              Expanded(
                flex: 10,
                child: Center(
                  child: Container(

                    margin: EdgeInsets.only(left: 20, right: 20, top: 100),
                    child: Column(

                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        input_field(hint:question1, Icons: Icons.question_answer_outlined, controller: answer1, keyboardType: TextInputType.text ),
                        input_field(hint: question2, Icons: Icons.question_answer_outlined, controller: answer2, keyboardType: TextInputType.text ),
                        input_field(hint: question3, Icons: Icons.question_answer_outlined, controller: answer3, keyboardType: TextInputType.text ),

                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Center(
                              child: Buttontwo(
                                btnText: "REGISTER",
                                Icons: Icons.how_to_reg,
                                onTab: (){
                                  if(answer1.text.toString() == "" || answer2.text.toString()==""|| answer3.toString()=="") {
                                    Fluttertoast.showToast(
                                        msg: "one of input cannot be empity!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                  else {
                                    forgotpass_register();

                                  }
                                },
                              ),

                            ),
                          ),
                        ),

                      ],
                    ),
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
