import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakuuza/screens/pages/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String username = "";
  String fullname = "";
  String numTel = "";
  String countLike = "";
  String countCmd = "";
  String email = "";
  String userID = "";

  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        userID = prefs.getString("userID") != null
            ? prefs.getString("userID").toString().trim()
            : "0";
        username = prefs.getString("username") != null
            ? prefs.getString("username").toString().trim()
            : "Nyiragongo";
        fullname = prefs.getString("nom") != null
            ? prefs.getString("nom").toString().trim()
            : "Nyiragongo Mobile app";
        numTel = prefs.getString("numTel") != null
            ? prefs.getString("numTel").toString().trim()
            : "00 00 00 00 00";
        countLike = prefs.getString("countLike") != null
            ? prefs.getString("countLike").toString().trim()
            : "0";
        countCmd = prefs.getString("countCmd") != null
            ? prefs.getString("countCmd").toString().trim()
            : "0";
        email = prefs.getString("email") != null
            ? prefs.getString("email").toString().trim() != "null"
                ? prefs.getString("email").toString().trim()
                : "info@nyiragongo.com"
            : "info@nyiragongo.com";
      });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) _getPref();
    _buildOrderedList();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        prefs.clear();
        print("logged out");
        _getPref();
        showInSnackBar("Votre compte est bien déconnecté !");
      });
  }

  _showDialog() async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text(
                "Log out",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              content: Text("Voulez-vous deconnecter votre compte?"),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Annuler",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    _logOut();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Valider",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ));
  }

  List<Widget> _list;
  List responseData = new List();

  _buildOrderedList() async {
    setState(() {
      responseData.clear();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("userID") != null
        ? prefs.getString("userID").toString().trim()
        : "0";
    if (userID != "" && userID != "0" && userID != null) {
      await http
          .post(BaseUrl.orderedList, body: {"userID": userID}).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          if ((response.body.toString().trim() != "data not found" &&
                  response.body.toString().trim() != "[]") &&
              response.statusCode == 200) {
            setState(() {
              responseData = json.decode(response.body);
            });
            // print(responseData.toString());
            setState(() {
              _buildData();
            });
          } else {
            showInSnackBar("Your order list is empry");
          }
        }
      }).catchError((err) {
        print(err.toString());
        showInSnackBar("Une erreur s'est produite");
      });
    } else {
      print(userID);
    }
  }

  _buildData() async {
    _list = new List<Widget>();
    setState(() {
      _list.clear();
    });
    for (var i = 0; i < responseData.length; i++) {
      setState(() {
        _list.add(new OrderItem(
            responseData[i]["bagID"].toString().trim(),
            responseData[i]["image"].toString().trim(),
            responseData[i]["detail"].toString().trim(),
            responseData[i]["categorie"].toString().trim(),
            responseData[i]["oder_date"].toString().trim(),
            responseData[i]["qteCmd"].toString().trim(),
            responseData[i]["etat"].toString().trim(),
            responseData[i]["prix_ui"].toString().trim()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        elevation: 1.0,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getString("userID").toString().trim() != "" &&
                    prefs.getString("userID") != null) {
                  _showDialog();
                }
              }),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10),
            color: Colors.orange,
            child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 5),
                      image: DecorationImage(
                          image: AssetImage("images/products/blazer1.jpeg"),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  fullname.toString().trim(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
                // Text(
                //   numTel.toString().trim(),
                //   style: TextStyle(
                //       fontSize: 14,
                //       color: Colors.white,
                //       fontWeight: FontWeight.w600),
                // ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          username == "Zakuuza"
              ? MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new LoginScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 50, right: 50, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Login now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : new Container(),
          username != "Nyiragongo"
              ? Card(
                  margin: EdgeInsets.all(0),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(countCmd.toString().trim(),
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Commandes",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   width: 1,
                        //   height: 40,
                        //   decoration:
                        //       BoxDecoration(border: Border.all(color: Colors.grey)),
                        // ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(countLike.toString().trim(),
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Likes",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          username != "Nyiragongo"
              ? Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "Fullname",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        fullname.toString().trim(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      Divider(height: 10),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        email.toString().trim(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      Divider(height: 10),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Phone number",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        numTel.toString().trim(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      Divider(
                        height: 10,
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Last order"),
                Text(
                  "View all",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
              child: SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: _list == null ? <Widget>[] : _list,
            ),
          )),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String orderID;
  final String imgUrl;
  final String itemName;
  final String itemCategory;
  final String itemOrderDate;
  final String itemQty;
  final String itemStatuts;
  final String itemPrice;
  OrderItem(this.orderID, this.imgUrl, this.itemName, this.itemCategory,
      this.itemOrderDate, this.itemQty, this.itemStatuts, this.itemPrice);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(offset: Offset(0, 1), color: Colors.black26)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                height: 100,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage("images/products/blazer2.jpeg"),
                //         fit: BoxFit.cover,
                //         alignment: Alignment.topCenter)),
                child: FadeInImage(
                  placeholder: AssetImage("images/placeholder.gif"),
                  image: NetworkImage(BaseUrl.uploadUrl + this.imgUrl),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.itemName.toString().trim(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                this.itemCategory.toString().trim(),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "\$" + this.itemPrice.toString().trim(),
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "ID : " + this.orderID.toString().trim(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      this.itemOrderDate.toString().trim(),
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          this.itemQty.toString().trim(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          this.itemStatuts.toString().trim(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
