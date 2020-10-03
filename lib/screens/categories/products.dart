// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zakuuza/model/api.dart';
// import 'package:zakuuza/screens/pages/prodDetails.dart';
import 'package:zakuuza/screens/pages/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Products extends StatefulWidget {
  final List products;

  const Products({this.products});
  @override
  _ProductsState createState() => new _ProductsState();
}

String userID = "user";

class _ProductsState extends State<Products> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted)
      setState(() {
        userID = prefs.getString('userID') != null
            ? prefs.getString('userID')
            : "user";
      });
  }

  @override
  void initState() {
    super.initState();
    _getUserID();
  }

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.products.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return new SingleProduct(products: widget.products, index: index);
        });
  }
}

class SingleProduct extends StatelessWidget {
  final List products;
  final int index;

  SingleProduct({this.products, this.index});

  @override
  Widget build(BuildContext context) {
    print(BaseUrl.uploadUrl + products[index]['image']);
    return Card(
      margin: EdgeInsets.all(5),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new ProductDetails(
                    products: products,
                    index: index,
                  ));
          Navigator.of(context).push(route);
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              ),
              child: FadeInImage(
                width: double.maxFinite,
                height: double.maxFinite,
                placeholder: AssetImage(
                  "images/placeholder.gif",
                ),
                image:
                    NetworkImage(BaseUrl.uploadUrl + products[index]['image']),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              // top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    borderRadius: BorderRadius.circular(3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${products[index]['detail']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "\$${products[index]['prix_ui']}",
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.person,
                                color: Colors.white70,
                                size: 20,
                              ),
                              Text(
                                "${products[index]['countLike']}",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.favorite,
                          color: products[index]['ref_pro'].toString().trim() ==
                                  products[index]['id'].toString().trim()
                              ? products[index]['ref_client']
                                          .toString()
                                          .trim() ==
                                      userID.toString().trim()
                                  ? Colors.red
                                  : Colors.white
                              : Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
