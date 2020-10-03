// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:zakuuza/menu.dart';
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/order_list.dart';
import 'package:zakuuza/model/product_mdl.dart';
// import 'package:zakuuza/screens/categories/products.dart';
import 'package:zakuuza/screens/pages/cart/cart1.dart';
import 'package:zakuuza/screens/widgets/custom_float.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakuuza/screens/pages/login/login_screen.dart';
// import 'package:zakuuza/model/user_mdl.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  final List products;
  final int index;

  ProductDetails({this.products, this.index});

  @override
  _ProductDetailsState createState() => new _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String responseData = "";
  String userID = "user";
  Color likedColor = Colors.orange;
  IconData likeIcon = Icons.favorite_border;
  bool isImgOverlayVisible = false;
  String imgOverlayPath = "";

  _launchURL(String newUrl) async {
    String url = newUrl;
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('userID') != null
          ? prefs.getString('userID')
          : "user";
      if (widget.products[widget.index]['ref_pro'].toString().trim() ==
              widget.products[widget.index]['id'].toString().trim() &&
          userID.toString().trim() != "user") {
        likeIcon = Icons.favorite;
        likedColor = Colors.red;
        print("is done");
      } else {
        likeIcon = Icons.favorite_border;
        likedColor = Colors.orange;
        print("not liked");
      }
    });
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username");
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  TextEditingController _pwdController = new TextEditingController();
  String username = "";

  postBag(String userID) async {
    try {
      final url = BaseUrl.panierUrl;
      final detail = BaseUrl.panierdetailsUrl;
      final response =
          await http.post(url, body: {
            "userID": userID.toString().trim(),
            "total": (widget.products[widget.index]['prix_ui']).toString().trim()
            });
      // final response = await http.post(urls);
      if (response.statusCode == 200) {
        print(response.body);
        var id = json.decode(response.body)[0]['id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
          await http.post(detail, body: {
            "bagID": id,
            "productID":  widget.products[widget.index]['id'],
            "qty": "1",
          }).then((res){
            // print(res);
            String result=json.decode(res.body);//[0]['message']
            print(result.toString());
            if(result=="Save succes")
            {
              setState(() {
                OrderList.products.clear();
              });
              Navigator.of(context).pop();
              var urls='https://api-testbed.maxicashapp.com/payentry?data={"PayType":"MaxiCash","Amount":"'+(double.parse(widget.products[widget.index]['prix_ui'])*100).toString().trim()+'",Currency:"maxiDollar","Telephone":"0973697114","MerchantID":"6db7867d56b34d92949ba61ffa556a5d","MerchantPassword":"9954bddd185f445c90d8f5cd1bbb2d9b","Language":"fr","Reference":"${id.toString().trim()}","accepturl":"https://www.zakuuza.com/API/api/accept/acceptUrl.php","cancelurl":"https://www.zakuuza.com/API/api/accept/failUrl.php","declineurl":"https://www.zakuuza.com/API/api/accept/failUrl.php","notifyURL":"ffffffff"}';
              _launchURL(urls);
              prefs.setString("countCmd",
                  (int.parse(prefs.getString('countCmd')) + 1).toString());
            }
          }).catchError((err){
            print(err);
          });
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
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
      // print(response.body);
      if (response.body.toString().trim() != "data not found" &&
          response.body.toString().trim() != "[]") {
        // print(Users.fromJson(json.decode(response.body)[0]));
        _pwdController.text = "";
        List responseData = new List();
        responseData = json.decode(response.body) as List;
        var userID = json.decode(responseData[0]['code_client']);
        // print(responseData[0]['code_client']);
        Navigator.of(context).pop();
        OrderList.add2Cart(Product.fromJson(
            widget.products[int.parse(widget.index.toString().trim())]));
        postBag(userID.toString().trim());
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

  _addLike(String prodID, String userID) async {
    http.post(BaseUrl.addLike,
        body: {"prodID": prodID, "clientID": userID}).then((response) {
      setState(() {
        responseData = json.decode(response.body.toString().trim());
      });
      if (responseData == "success") {
        setState(() async {
          likedColor = Colors.red;
          likeIcon = Icons.favorite;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("countLike",
              (int.parse(prefs.getString('countLike')) + 1).toString());
        });
      } else {}
    }).catchError((err) {});
  }

  List<Widget> _items = new List<Widget>();
  _buildImg() async {
    _items.add(MaterialButton(
      padding: EdgeInsets.all(0),
      minWidth: 0,
      onPressed: () {
        setState(() {
          isImgOverlayVisible = true;
          imgOverlayPath =
              BaseUrl.uploadUrl + widget.products[widget.index]['image'];
        });
      },
      child: Container(
        margin: EdgeInsets.all(0),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: FadeInImage(
          placeholder: AssetImage(
            "images/placeholder.gif",
          ),
          image: widget.products[widget.index]['image'] != null
              ? NetworkImage(
                  BaseUrl.uploadUrl + widget.products[widget.index]['image'])
              : AssetImage(
                  "images/placeholder.gif",
                ),
          fit: BoxFit.cover,
        ),
      ),
    ));
    _items.add(MaterialButton(
      padding: EdgeInsets.all(0),
      minWidth: 0,
      onPressed: () {
        setState(() {
          isImgOverlayVisible = true;
          imgOverlayPath =
              BaseUrl.uploadUrl + widget.products[widget.index]['image2'];
        });
      },
      child: Container(
        margin: EdgeInsets.all(0),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: FadeInImage(
          placeholder: AssetImage(
            "images/placeholder.gif",
          ),
          image: widget.products[widget.index]['image2'] != null
              ? NetworkImage(
                  BaseUrl.uploadUrl + widget.products[widget.index]['image2'])
              : AssetImage(
                  "images/placeholder.gif",
                ),
          fit: BoxFit.cover,
        ),
      ),
    ));
    _items.add(MaterialButton(
      padding: EdgeInsets.all(0),
      minWidth: 0,
      onPressed: () {
        setState(() {
          isImgOverlayVisible = true;
          imgOverlayPath =
              BaseUrl.uploadUrl + widget.products[widget.index]['image3'];
        });
      },
      child: Container(
        margin: EdgeInsets.all(0),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: FadeInImage(
          placeholder: AssetImage(
            "images/placeholder.gif",
          ),
          image: widget.products[widget.index]['image3'] != null
              ? NetworkImage(
                  BaseUrl.uploadUrl + widget.products[widget.index]['image3'])
              : AssetImage(
                  "images/placeholder.gif",
                ),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }

  int qteCmd = 1;

  @override
  void initState() {
    super.initState();
    _getUserID();
    _buildImg();
  }

  @override
  Widget build(BuildContext context) {
    int orderCount = OrderList.products.length;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(
                    "${widget.products[widget.index]['detail']}".toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  pinned: true,
                  expandedHeight: 250,
                  floating: true,
                  backgroundColor: Colors.orange,
                  actions: <Widget>[
                    CustomFloat(
                      builder: Text(
                        '$orderCount',
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      ),
                      icon: Icons.shopping_cart,
                      qrCallback: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new CartOnePage(products: OrderList.products),
                          ),
                        );
                      },
                    )
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: widget.products[widget.index]['image'] != null
                          ? Image.network(
                              BaseUrl.uploadUrl +
                                  widget.products[widget.index]['image'],
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              color: Color.fromRGBO(20, 20, 20, 0.4),
                              colorBlendMode: BlendMode.darken,
                              filterQuality: FilterQuality.high,
                            )
                          : Image.asset("images/placeholder.gif")),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    Card(
                      margin: EdgeInsets.all(0),
                      elevation: 2.0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "${widget.products[widget.index]['detail']}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                    "\$${widget.products[widget.index]['prix_ui']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Text("Description",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                    "Description du produit ici " +
                                        widget.products[widget.index]['id']
                                            .toString()
                                            .trim(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(5),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _items,
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Prix : ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    "\$${widget.products[widget.index]['prix_ui']}"),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () {
                                          OrderList.add2Cart(Product.fromJson(
                                              widget.products[int.parse(widget
                                                  .index
                                                  .toString()
                                                  .trim())]));
                                          setState(() {
                                            orderCount =
                                                OrderList.products.length;
                                          });
                                          // print(widget.index);
                                        },
                                        padding: EdgeInsets.all(0),
                                        minWidth: 10,
                                        child: Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          if (userID.toString().trim() !=
                                              "user") {
                                            _addLike(
                                                widget.products[widget.index]
                                                        ['id']
                                                    .toString()
                                                    .trim(),
                                                userID.toString().trim());
                                            print("Is logged");
                                          } else {
                                            Navigator.of(context).push(
                                                new MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new LoginScreen()));
                                          }
                                        },
                                        padding: EdgeInsets.all(0),
                                        minWidth: 10,
                                        child: Icon(
                                          widget.products[widget.index]
                                                          ['ref_pro']
                                                      .toString()
                                                      .trim() ==
                                                  widget.products[widget.index]
                                                          ['id']
                                                      .toString()
                                                      .trim()
                                              ? widget.products[widget.index]
                                                              ['ref_client']
                                                          .toString()
                                                          .trim() ==
                                                      userID.toString().trim()
                                                  ? likeIcon
                                                  : likeIcon
                                              : likeIcon,
                                          color: widget.products[widget.index]
                                                          ['ref_pro']
                                                      .toString()
                                                      .trim() ==
                                                  widget.products[widget.index]
                                                          ['id']
                                                      .toString()
                                                      .trim()
                                              ? widget.products[widget.index]
                                                              ['ref_client']
                                                          .toString()
                                                          .trim() ==
                                                      userID.toString().trim()
                                                  ? likedColor
                                                  : likedColor
                                              : likedColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Qte : ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(qteCmd.toString().trim()),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                username = prefs.getString("username");

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
                              },
                              child: Card(
                                color: Colors.orange,
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  // color: Colors.orange,
                                  child: Text(
                                    "Passer la commande",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Details du produit",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Categorie",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "${widget.products[widget.index]['categorie']}",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Fournisseur",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "${widget.products[widget.index]['fss']}",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Stock",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "${widget.products[widget.index]['qte']}" +
                                  " pièces",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Nombre des commandes",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              widget.products[widget.index]['countCmd'] != null
                                  ? widget.products[widget.index]['countCmd'] +
                                      " fois"
                                  : "0" + " fois",
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Likes",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              widget.products[widget.index]['countLike'] != null
                                  ? widget.products[widget.index]['countLike']
                                  : "0",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Visibility(
                visible: isImgOverlayVisible,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.7),
                      ),
                      child: Image.network(
                        imgOverlayPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                        top: 40,
                        right: 10,
                        child: MaterialButton(
                          padding: EdgeInsets.all(0),
                          minWidth: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 1),
                                      color: Colors.black26)
                                ]),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isImgOverlayVisible = false;
                              imgOverlayPath = "";
                            });
                          },
                        ))
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
