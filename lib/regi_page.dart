import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fermata/utils/color.dart';
import 'package:fermata/widgets/btn_widget.dart';
import 'package:fermata/widgets/header_container.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fermata/Find_Me/find_me_current_location.dart';


import 'login_page.dart';

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  TextEditingController full_name = TextEditingController();
  TextEditingController phone_number = TextEditingController();
  TextEditingController ICE_contact = TextEditingController();
  TextEditingController ICE_message = TextEditingController();


  // Future<bool> _onBackPressed(){
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context){
  //         return exit(0);
  //       }
  //   );
  // }

  Future register() async {
    print("wtfffffffffff!!!");
    var url = Uri.parse("http://10.240.72.97:1111/Contact/save");


    var response = await http.post(url, body: {

      "name": full_name.text,
      "username": phone_number.text,
      "phone": ICE_contact.text,
      "token":  "_32049359",
      //"ICE_number": ICE_message.text,
    });

    var data = json.decode(response.body);
    print(response.body);
    if (data["header"]["error"]=="true") {
      Fluttertoast.showToast(
          msg: "access denied!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      Fluttertoast.showToast(
          msg: "Registration Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage(),),);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        //onWillPop: _onBackPressed,
        child: Container(
          height: 5.0,
          width: 18.0,
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              HeaderContainer("Register"),
              Expanded(
                flex: 100,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      input_field(hint: "Full Name", Icons: Icons.person, controller: full_name, keyboardType: TextInputType.text ),
                      input_phone_validator(hint: "Phone Number", Icons: Icons.call, controller: phone_number, keyboardType: TextInputType.text, ),
                      input_field(hint: "Emergency contact", Icons: Icons.add_ic_call,controller: ICE_contact, keyboardType: TextInputType.phone),
                      input_field(hint: "Emergency Message", Icons: Icons.add_comment_sharp,controller: ICE_message, keyboardType: TextInputType.text),
                      Expanded(
                        child: Center(

                          child: ButtonWidget(
                            btnText: "REGISTER",
                            onClick: () {
                              register();

                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Login",
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
