import 'package:flutter/material.dart';
// import 'package:zakuuza/model/order_list.dart';
// import 'package:zakuuza/model/product_mdl.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;
  final String productPrice;
  final String productImg;
  ProductDetailsPage(this.productName, this.productPrice, this.productImg);
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int qteCmd = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: Text(
                    widget.productName.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  pinned: true,
                  expandedHeight: 250,
                  floating: true,
                  backgroundColor: Colors.orange,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                      background: Image.network(
                    widget.productImg,
                    fit: BoxFit.cover,
                    color: Color.fromRGBO(20, 20, 20, 0.4),
                    colorBlendMode: BlendMode.darken,
                    filterQuality: FilterQuality.high,
                  )),
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
                                  widget.productName,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("\$" + widget.productPrice,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            SizedBox(height: 20,),
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
                                Text("Description du produit ici",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ],
                        ),
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
                                Text("\$ " + widget.productPrice),
                                Expanded(
                                  
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Icon(Icons.favorite_border, color: Colors.orange,),
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
                                MaterialButton(
                                  minWidth: 20,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    setState(() {
                                      if (qteCmd >= 1) {
                                        qteCmd--;
                                      }
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  minWidth: 20,
                                  onPressed: () {
                                    setState(() {
                                      qteCmd++;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            MaterialButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                
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
                              children: <Widget>[Text("Details du produit", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)],
                            ),
                            SizedBox(height: 20,),
                            Text("Categorie", style: TextStyle(color: Colors.grey),),
                            SizedBox(height: 5,),
                            Text(widget.productName, style: TextStyle(color: Colors.black),),

                            SizedBox(height: 20,),
                            Text("Fournisseur", style: TextStyle(color: Colors.grey),),
                            SizedBox(height: 5,),
                            Text("China", style: TextStyle(color: Colors.black),),

                            SizedBox(height: 20,),
                            Text("Stock", style: TextStyle(color: Colors.grey),),
                            SizedBox(height: 5,),
                            Text("120" +" pièces", style: TextStyle(color: Colors.black),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 30),
                      child: Column(
                        children: <Widget>[
                          
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.black12, offset: Offset(0, -1))
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.add_shopping_cart,
                      size: 30,
                      color: Colors.orange,
                    ),
                    Icon(
                      Icons.remove_shopping_cart,
                      color: Colors.orange,
                      size: 30,
                    ),
                    Icon(
                      Icons.markunread,
                      color: Colors.orange,
                      size: 30,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
