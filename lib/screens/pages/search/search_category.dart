import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';
import 'dart:convert';
import 'package:zakuuza/screens/pages/product_details.dart';

class SearchCategoryScreen extends StatefulWidget {
  final String categoryName;
  SearchCategoryScreen({this.categoryName});
  // static final String path = "lib/src/pages/ecommerce/ecommerce2.dart";

  @override
  _SearchCategoryScreenState createState() => _SearchCategoryScreenState();
}

class _SearchCategoryScreenState extends State<SearchCategoryScreen> {
  @override
  void initState() { 
    super.initState();
    _searchData();
  }
  String searchValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        actions: <Widget>[
        ],
        backgroundColor: Colors.white70,
        title: Text(
          widget.categoryName.toString().trim(),
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        // centerTitle: true,
        // bottom: _buildBottomBar(),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            Text(
              "Resultats de la recherche pour '" +
                  searchValue.toString().trim() +
                  "'",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            // _buildSearchedItem(),
            Container(
              child: Column(
                children: listItems,
              ),
            )
            // listItems
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // -------------------------Search funciton-------------------------
  List responseData = new List();
  List<Widget> listItems = new List<Widget>();
  _searchData() async {
    setState(() {
      responseData.clear();
      listItems.clear();
    });
    if (widget.categoryName.toString().trim() == "") {
    } else {
      setState(() {
        searchValue = widget.categoryName.toString().trim();
      });
      await http
          .get(BaseUrl.searchData +
              "&searchValue=" +
              widget.categoryName.toString().trim())
          .then((response) {
        if (json.decode(response.body) == "Not found" ||
            json.decode(response.body) ==
                "PHP EXCEPTION : CAN'T CONNECT TO MYSQL") {
          setState(() {
            listItems.add(new EmptyModel());
          });
        } else {
          responseData = json.decode(response.body);
          for (var i = 0; i < responseData.length; i++) {
            setState(() {
              listItems.add(new SearchModel(
                  responseData, int.parse(i.toString().trim())));
            });
          }
        }
      });
    }
  }
}

class SearchModel extends StatelessWidget {
  final List product;
  final int index;
  SearchModel(this.product, this.index);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){
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