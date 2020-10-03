import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zakuuza/model/api.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final String background = 'images/SignUpbg.jpg';
  bool _saving = false;
  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _fullname = new TextEditingController();
  TextEditingController _telephone = new TextEditingController();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password1 = new TextEditingController();
  TextEditingController _password2 = new TextEditingController();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  signUpAction() {
    if (_fullname.text.isEmpty) {
      return showInSnackBar("fullname is empty");
    }
    if (_username.text.isEmpty) {
      return showInSnackBar("username is empty");
    }
    if (_telephone.text.isEmpty) {
      return showInSnackBar("telephone is empty");
    }
    if (_password1.text.isEmpty) {
      return showInSnackBar("password is empty");
    }
    if (_password2.text.isEmpty) {
      return showInSnackBar("confirm your password");
    }
    if (_password1.text != _password2.text) {
      return showInSnackBar("passwords must be the same");
    }
    signeUp();
  }

  Future signeUp() async {
    try {
      setState(() {
        _saving = true;
      });

      final jsonEndPoint = BaseUrl.signin;
      final response = await http.post(jsonEndPoint, body: {
        "fullname": _fullname.text,
        "username": _username.text,
        "telephone": _telephone.text,
        "pwd": _password1.text,
      });
      var datauser = json.decode(response.body);

      if (datauser.toString() == "{code: 0, message: Save error}") {
        setState(() {
          _saving = false;
          msg = "Save error";
        });
        print(datauser);
      } else {
        setState(() {
          _saving = false;
          msg = "Save succes";
        });
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _saving = false;
      });
      msg = "Echec de connexion";
      return showInSnackBar(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
            // backgroundColor: Theme.of(context).primaryColor,
            ),
        inAsyncCall: _saving,
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() => Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
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
                            "Nyiragongo",
                            style:
                                TextStyle(color: Colors.orange, fontSize: 30.0),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Create your free account now!",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: _fullname,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Fullname",
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
                      controller: _telephone,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Telephone",
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
                      controller: _username,
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
                      controller: _password1,
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
                      height: 10.0,
                    ),
                    TextField(
                      controller: _password2,
                      obscureText: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Confirm your password",
                        hintStyle: TextStyle(color: Colors.black26),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: Text(
                          "Sigi In".toUpperCase(),
                        ),
                        onPressed: () => signUpAction(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Already have an account ?",
                          style:
                              TextStyle(color: Colors.black26, fontSize: 14.0),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
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
