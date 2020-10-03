import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/screens/pages/login/login.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _countryCode = "+243";

  String msg = "";

  TextEditingController _email = new TextEditingController();
  TextEditingController _fullname = new TextEditingController();
  TextEditingController _telephone = new TextEditingController();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password1 = new TextEditingController();
  TextEditingController _password2 = new TextEditingController();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  signUpaction() {
    if (_fullname.text.isEmpty) {
      return showInSnackBar("fullname is empty");
    }
    if (_email.text.isEmpty) {
      return showInSnackBar("email is empty");
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
      return showInSnackBar("password is empty");
    }
    signeUp();
  }

  Future signeUp() async {
    try {
      final jsonEndPoint = BaseUrl.signin;

    final response = await http.post(jsonEndPoint, body: {
      "fullname": _fullname.text,
      "email": _email.text,
      "username": _username.text,
      "pwd": _password1.text,
      "telephone": _countryCode + "" + _telephone.text
    });
    var datauser = json.decode(response.body);

    if (datauser.toString() == "{code: 0, message: Save error}") {
      setState(() {
        msg = "Save error";
      });
    } else {
      setState(() {
        msg = "Save succes";
      });
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    }
    } catch (e) {
      msg = "Echec de connexion";
      return showInSnackBar(msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: signupBody(),
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    // setState(() {
    _countryCode = countryCode.toString();
    // });
    print(_countryCode);
  }

  signupBody() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[signupHeader(), signupFields()],
        ),
      );

  signupHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Icon(Icons.shopping_basket, color: Colors.orange),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Welcome to Nyiragongo",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Sign un to continue",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  signupFields() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextFormField(
                controller: _fullname,
                maxLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your fullname",
                  labelText: "Fullname",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextFormField(
                controller: _email,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your email address",
                  labelText: "Email",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextFormField(
                maxLength: 9,
                controller: _telephone,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  icon: CountryCodePicker(
                    onChanged: _onCountryChange,
                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                    initialSelection: 'CD',
                    favorite: ['+243', 'DRC'],
                    // optional. Shows only country name and flag
                    showCountryOnly: false,
                  ),
                  prefixText: _countryCode,
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "- - - - - - - - -",
                  labelText: "telephone",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextFormField(
                controller: _username,
                cursorColor: Colors.orange,
                maxLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your username",
                  labelText: "Username",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: TextFormField(
                controller: _password1,
                cursorColor: Colors.orange,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Enter your password",
                  labelText: "Password",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextFormField(
                controller: _password2,
                cursorColor: Colors.orange,
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "Confirm your password",
                  labelText: "Password",
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
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
                  signUpaction();
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.orange,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new LoginPage()));
                },
              ),
            ),
          ],
        ),
      );
}
