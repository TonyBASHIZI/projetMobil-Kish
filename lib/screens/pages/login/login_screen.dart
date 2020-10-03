import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/user_mdl.dart';
import 'package:zakuuza/screens/pages/login/sign_up_screen.dart';
// import 'package:zakuuza/screens/pages/order/confirm_order.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String background = 'images/loginbg.jpg';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String msg = "";
  bool _saving = false;
  List responseData = new List();
  _saveUserData(String userID, String nom, String numTel, String username,
      String countCmd, String countLike, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("userID", userID);
      prefs.setString("nom", nom);
      prefs.setString("numTel", numTel);
      prefs.setString("username", username);
      prefs.setString("countCmd", countCmd);
      prefs.setString("countLike", countLike);
      prefs.setString("email", email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
            // backgroundColor: Theme.of(context).primaryColor,
            ),
        inAsyncCall: _saving,
        child: buildBody(),
      ),
    );
  }

  logUser() {
    if (username.text.isEmpty) {
      return showInSnackBar("Username is empty");
    }
    if (password.text.isEmpty) {
      return showInSnackBar("password is empty");
    }
    _login();
  }

  Future _login() async {
    setState(() {
      _saving = true;
    });
    final url = BaseUrl.login;
    final response = await http.post(
      url,
      body: {
        "username": username.text,
        "pwd": password.text,
      },
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      if (response.body.toString() != "[]" &&
          json.decode(response.body.toString()) != "data not found") {
        setState(() {
          msg = "Vous etes bien connecté";
          responseData = json.decode(response.body);
          _saveUserData(
              responseData[0]['code_client'].toString().trim(),
              responseData[0]['nom'].toString().trim(),
              responseData[0]['tel'].toString().trim(),
              responseData[0]['username'].toString().trim(),
              responseData[0]['countCmd'].toString().trim(),
              responseData[0]['countLike'].toString().trim(),
              responseData[0]['email'].toString().trim());
        });
        print(Users.fromJson(json.decode(response.body)[0]));
        Navigator.of(context).pop();
        // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ConfirmOrderPage(users: Users.fromJson(json.decode(response.body)[0],),),),);
      } else {
        setState(() {
          _saving = false;
          msg = "Username or password incorrect";
        });
        showInSnackBar(msg);
      }
    } else {
      setState(() {
        _saving = false;
        msg = "Echec de connexion";
      });
      showInSnackBar(msg);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget buildBody() => Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white.withOpacity(1),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height/10,
                    // ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(1, 2))
                                ],
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(100)),
                            child: Image.asset("images/logoKis.jpeg"),
                          ),
                          Text(
                            "Nyiragongo Soft",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Sign in to continue",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   "zakuuza",
                    //   style: TextStyle(color: Colors.black, fontSize: 28.0),
                    // ),

                    SizedBox(
                      height: 30.0,
                    ),
                    TextField(
                      controller: username,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.black26),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: password,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.black26),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Forgot your password ?",
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.orange,
                        child: Text(
                          "Sigi In".toUpperCase(),
                        ),
                        onPressed: () {
                          logUser();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Dont have an account ?",
                          style:
                              TextStyle(color: Colors.black26, fontSize: 14.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _saving = true;
                            });
                            new Future.delayed(Duration(microseconds: 200000),
                                () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()));
                              setState(() {
                                _saving = false;
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
