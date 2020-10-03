import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/user_mdl.dart';
import 'package:zakuuza/screens/pages/login/registration_screen.dart';
import 'package:zakuuza/screens/pages/payment/payment_success_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  String msg = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: loginBody(),
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
    final url = BaseUrl.login;
    final response = await http.post(
      url,
      body: {
        "username": username.text,
        "pwd": password.text,
      },
    );
    if (response.statusCode == 200) {
      if (response.body.toString() != "[]") {
        setState(() {
          msg = "Vous etes bien connecté";
        });
        Navigator.of(context).pushReplacement(
          new MaterialPageRoute(
            builder: (BuildContext context) => new PaymentSuccessPage(
              users: Users.fromJson(json.decode(response.body)[0]),
            ),
          ),
        );
      } else {
        setState(() {
          msg = "Username or password incorrect";
        });
        showInSnackBar(msg);
      }
    } else {
      setState(() {
        msg = "erreur de serveur";
      });
      showInSnackBar(msg);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  loginBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields()],
        ),
      );

  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircleAvatar(backgroundImage: AssetImage("images/logoKis.jpeg")),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "Welcome to Nyiragongo",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Sign in to continue",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  loginFields() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextFormField(
                controller: username,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  border: UnderlineInputBorder(),
                  hintText: "Enter your username",
                  labelText: "Username",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextFormField(
                controller: password,
                cursorColor: Colors.orange,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  border: UnderlineInputBorder(),
                  hintText: "Enter your password",
                  labelText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text(
                  "SIGN IN",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.orange,
                onPressed: () {
                  logUser();
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              padding: EdgeInsets.all(12.0),
              shape: StadiumBorder(),
              child: Text(
                "SIGN UP FOR AN ACCOUNT",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SignUpPage()));
              },
            ),
          ],
        ),
      );
}
