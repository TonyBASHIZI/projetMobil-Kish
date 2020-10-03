import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';
import 'dart:convert';
import 'package:zakuuza/screens/pages/product_details.dart';

class SearchScreen extends StatefulWidget {
  static final String path = "lib/src/pages/ecommerce/ecommerce2.dart";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
        ],
        backgroundColor: Colors.white70,
        title: Text(
          'Search products',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        // centerTitle: true,
        bottom: _buildBottomBar(),
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

  // Widget _buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     items: <BottomNavigationBarItem>[
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.category), title: Text("Shop")),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.favorite_border), title: Text("Favorites")),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.notifications), title: Text("Notifications")),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.location_on), title: Text("Near me")),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.settings), title: Text("Settings")),
  //     ],
  //     currentIndex: 0,
  //     type: BottomNavigationBarType.fixed,
  //     fixedColor: Colors.red,
  //   );
  // }

  // -------------------------Search funciton-------------------------
  List responseData = new List();
  List<Widget> listItems = new List<Widget>();
  _searchData() async {
    setState(() {
      responseData.clear();
      listItems.clear();
    });
    if (_searchController.text.toString().trim() == "") {
    } else {
      setState(() {
        searchValue = _searchController.text.toString().trim();
      });
      await http
          .get(BaseUrl.searchData +
              "&searchValue=" +
              _searchController.text.toString().trim())
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

  TextEditingController _searchController = new TextEditingController();
  PreferredSize _buildBottomBar() {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Card(
          child: Container(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: IconButton(
                    onPressed: () {
                      _searchData();
                    },
                    icon: Icon(Icons.search)),
                // suffixIcon: IconButton(onPressed: (){}, icon: Icon(Icons.mic))
              ),
            ),
          ),
        ),
      ),
      preferredSize: Size.fromHeight(80.0),
    );
  }

  // Widget _buildShopItem(Map item) {
  //   return Container(
  //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
  //     margin: EdgeInsets.only(bottom: 20.0),
  //     height: 300,
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //             child: Container(
  //           decoration: BoxDecoration(
  //               image: DecorationImage(
  //                   image: AssetImage(item["image"]), fit: BoxFit.cover),
  //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //               boxShadow: [
  //                 BoxShadow(
  //                     color: Colors.grey,
  //                     offset: Offset(5.0, 5.0),
  //                     blurRadius: 10.0)
  //               ]),
  //         )),
  //         Expanded(
  //           child: Container(
  //             padding: EdgeInsets.all(20.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text(
  //                   item["title"],
  //                   style:
  //                       TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
  //                 ),
  //                 SizedBox(
  //                   height: 10.0,
  //                 ),
  //                 Text(item["category"],
  //                     style: TextStyle(color: Colors.grey, fontSize: 14.0)),
  //                 SizedBox(
  //                   height: 20.0,
  //                 ),
  //                 Text("\$${item["price"].toString()}",
  //                     style: TextStyle(
  //                       color: Colors.red,
  //                       fontSize: 24.0,
  //                     )),
  //                 SizedBox(
  //                   height: 10.0,
  //                 ),
  //                 Text(item["tags"],
  //                     style: TextStyle(
  //                         fontSize: 16.0, color: Colors.grey, height: 1.5))
  //               ],
  //             ),
  //             margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.only(
  //                     bottomRight: Radius.circular(10.0),
  //                     topRight: Radius.circular(10.0)),
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Colors.grey,
  //                       offset: Offset(5.0, 5.0),
  //                       blurRadius: 10.0)
  //                 ]),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
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
