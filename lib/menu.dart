import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/order_list.dart';
import 'package:zakuuza/screens/categories/horizontal_list.dart';
import 'package:zakuuza/screens/categories/products.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/screens/pages/cart/cart1.dart';
import 'package:zakuuza/screens/widgets/color_loader_4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakuuza/screens/pages/product_details.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => new _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserdata();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String userID = "0";
  _getUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        userID = prefs.getString("userID") != null
            ? prefs.getString("userID").toString().trim()
            : "0";
      });
  }

  //making widget to increase the readability
  Container image_carousel = new Container(
    height: 150.0,
    child: new Carousel(
      showIndicator: true,
      overlayShadow: false,
      borderRadius: true,
      boxFit: BoxFit.cover,
      autoplay: true,
      dotSize: 5.0,
      indicatorBgPadding: 8.0,
      images: [
        //new AssetImage('images/logoKis.jpeg'),
        new AssetImage('images/shop6.png'),
        //new AssetImage('images/logoKis.jpeg'),
        new AssetImage('images/shop6.png'),
        new AssetImage('images/shop6.png'),
      ],
      animationCurve: Curves.easeOutExpo,
      animationDuration: new Duration(milliseconds: 4000),
      autoplayDuration: new Duration(milliseconds: 5000),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.white24,
        title: new Text('Shop Soft'),
      ),
      body: new SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SizedBox(
                height: 0,
              ),

              //Image Carousel
              image_carousel,

              //padding
              new Padding(
                padding: const EdgeInsets.all(8.0),
                // child: new Text(
                //   'Categories'.toUpperCase(),
                //   style: TextStyle(
                //       // color: Colors.white,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
              // Horizontal ListView

              // Container(
              //   child: new HorizontalList(),
              // ),
              //padding
              new Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 3.0),
                child: new Text(
                  'Recent Products'.toUpperCase(),
                  style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),

              //making shopping products
              new Container(
                // height: 400,
                child: new FutureBuilder<List>(
                    future: getData(),
                    builder: (cxt, ss) {
                      if (ss.hasError)
                        new Center(
                            child: Text(
                          'Cannot find data',
                          style: TextStyle(color: Colors.grey),
                        ));
                      return Center(
                          child: ss.hasData
                              ? new Products(
                                  products: ss.data,
                                )
                              : new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CupertinoActivityIndicator(),
                                    Text(
                                      'Loading',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ));
                    }),
              )
            ]),
      ),
    );
  }

  bool errorOcured = true;
  List searchData = new List();

  Future<List> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("userID") != null
        ? prefs.getString("userID").toString().trim()
        : "0";

    // if(mounted)
    //   setState(() {
    //     userID=prefs.getString("userID")!=null?prefs.getString("userID").toString().trim():"0";
    //   });
    final response = await http.get(
        BaseUrl.selectProduct + "&userID=" + userID.toString().trim() + "");
    print(response.body);
    return json.decode(response.body);
  }
}

// final response=await http.get(BaseUrl.selectProduct+"&userID="+userID.toString().trim()+"").then((response){
//       errorOcured=false;
//       setState(() {
//        responseData=json.decode(response.body);
//       });
//     }).catchError((err){
//       setState(() {
//        errorOcured=true;
//        return;
//       });
//       showInSnackBar("Connexion error");
//     });

class SearchModel extends StatelessWidget {
  final List product;
  final int index;
  SearchModel(this.product, this.index);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new ProductDetails(
                  products: product,
                  index: index,
                ));
        Navigator.of(context).push(route);
      },
      padding: EdgeInsets.all(0),
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                // width: 70,
                height: 100,
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black),
                    image: DecorationImage(
                        image: NetworkImage(
                            "${BaseUrl.uploadUrl}${product[index]['image']}"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product[index]['detail'].toString().trim(),
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      product[index]['categorie'].toString().trim(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\$" + product[index]['prix_ui'],
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
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

class EmptyModel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          Icon(
            Icons.delete_sweep,
            color: Colors.grey,
            size: 70,
          ),
          Text(
            "Aucun résultat trouvé",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
