// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zakuuza/model/order_list.dart';
// import 'package:zakuuza/model/product_mdl.dart';
import 'package:zakuuza/screens/pages/login/login_screen.dart';
// import 'package:zakuuza/screens/pages/profile.dart';
import 'package:zakuuza/screens/pages/order/confirm_order.dart';
import 'package:zakuuza/model/user_mdl.dart';
import 'dart:convert';
import 'package:zakuuza/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartOnePage extends StatefulWidget {
  final List products;

  const CartOnePage({Key key, this.products}) : super(key: key);
  @override
  _CartOnePageState createState() => _CartOnePageState();
}

class _CartOnePageState extends State<CartOnePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _getUserData();
  }

  double getSumPrice() {
    double totalPrice = 0;
    if (widget.products.length == 0) {
      totalPrice = 0;
    } else {
      for (var i = 0; i < widget.products.length; i++) {
        double qty =
            widget.products[i].qteCmd == null ? 1 : widget.products[i].qteCmd;
        totalPrice +=
            qty * double.tryParse(widget.products[i].prix_ui.toString());
      }
    }
    OrderList.total = totalPrice;
    return OrderList.total;
  }

  TextEditingController _pwdController = new TextEditingController();
  String username = "";

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
    });
  }

  _checkPWD() async {
    _getUserData();
    final url = BaseUrl.login;
    final response = await http.post(
      url,
      body: {
        "username": username,
        "pwd": _pwdController.text,
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      if (response.body.toString().trim() != "data not found" &&
          response.body.toString().trim() != "[]") {
        // print(Users.fromJson(json.decode(response.body)[0]));
        _pwdController.text = "";
        Navigator.of(context).pop();
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) => new ConfirmOrderPage(
                  users: Users.fromJson(
                    json.decode(response.body)[0],
                  ),
                ),
          ),
        );
      } else {
        setState(() {
          _pwdController.text = "";
          Navigator.of(context).pop();
          showInSnackBar("Mot de passe incorrecte");
        });
      }
    } else {
      _pwdController.text = "";
      Navigator.of(context).pop();
      showInSnackBar("Une erreur est survenue");
    }
  }

  double qteCmd = 1;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  _showDialog() async {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: Text(
                "Confirmer le mot de passe",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              content: TextFormField(
                controller: _pwdController,
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    if (_pwdController.text.toString().trim() != "") {
                      _checkPWD();
                      // print("match");
                      // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new ConfirmOrderPage(users: user,),),);
                    } else {
                      print("don't match");
                    }
                  },
                  child: Text("Valider"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Check out your cart"),
        backgroundColor: Colors.white70,
        // elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.products.length == 0
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.delete_sweep,
                            size: 100.0,
                            color: Colors.grey[300],
                          ),
                          Text('your shopping cart is empty')
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: widget.products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(right: 30.0, bottom: 10.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(5.0),
                                elevation: 3.0,
                                child: Container(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 100,
                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.all(0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // border: Border.all(color: Colors.black),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "${widget.products[index].image}"),
                                                  fit: BoxFit.cover,
                                                  alignment:
                                                      Alignment.topCenter)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${widget.products[index].detail}',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      '${widget.products[index].categorie}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "\$${widget.products[index].prix_ui}",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          "Qte: "+widget.products[index].qteCmdGet.toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Text(
                                                      "\$" +(widget.products[index].qteCmd *widget.products[index].prix_ui).toString() +"",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          child: Icon(Icons.remove_circle, color: Colors.grey, size: 20,),
                                                          onTap: (){
                                                            setState(() {
                                                              if (qteCmd > 1) {
                                                                qteCmd--;
                                                                widget
                                                                    .products[
                                                                        index]
                                                                    .qteCmdSet = qteCmd;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(width: 25,),
                                                        GestureDetector(
                                                          child: Icon(Icons.add_circle, color: Colors.orange, size: 20,),
                                                          onTap: (){
                                                            setState(() {
                                                              setState(() {
                                                              qteCmd++;
                                                              widget.products[index].qteCmdSet =qteCmd;
                                                            });
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              right: 5,
                              child: Container(
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.pinkAccent,
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      OrderList.remove2Cart(
                                          widget.products[index]);
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Subtotal      \$${getSumPrice()}",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    "Delivery       \$0",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    "Cart Subtotal     \$${getSumPrice()}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      padding: EdgeInsets.all(2),
                      height: 50.0,
                      color: Colors.pinkAccent,
                      child: Text(
                        "Secure Checkout".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        username = prefs.getString("username");
                        if (OrderList.products.length == 0) {
                          _scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: Text("Votre  panier est vide"),
                          ));
                        } else {
                          if (username.toString().trim() == "" ||
                              username == null) {
                            Navigator.of(context).push(
                              new MaterialPageRoute(
                                builder: (context) => new LoginScreen(),
                              ),
                            );
                          } else {
                            _showDialog();
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
