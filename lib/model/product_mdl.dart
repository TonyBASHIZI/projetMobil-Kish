import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';

class Product {
  final String id;
  final String design_produit,
      detail,
      image,
      fss,
      categorie,
      ref_pro,
      ref_client,
      countCmd,
      countLike,
      image2,
      image3;
  final double qty, prix_ui;
  double qteCmd = 1;

  Product(
      {this.fss,
      this.categorie,
      this.id,
      this.design_produit,
      this.detail,
      this.prix_ui,
      this.image,
      this.qty: 1,
      this.qteCmd: 1,
      this.ref_pro: "",
      this.ref_client: "",
      this.countCmd: "0",
      this.countLike: "0",
      this.image2,
      this.image3});

  factory Product.fromJson(Map<String, dynamic> jsonData) {
    return Product(
      id: jsonData['id'],
      design_produit: jsonData['design_produit'],
      detail: jsonData['detail'],
      prix_ui: double.tryParse(jsonData['prix_ui'].toString()),
      image: BaseUrl.uploadUrl + jsonData['image'],
      fss: jsonData['fss'],
      categorie: jsonData['categorie'],
      qty: double.tryParse(jsonData['qte'].toString().trim()),
      ref_pro: jsonData['ref_pro'],
      ref_client: jsonData['ref_client'],
      countCmd: jsonData['countCmd'],
      countLike: jsonData['countLike'],
      image2: jsonData['image2'],
      image3: jsonData['image3'],
    );
  }
  void set qteCmdSet(value) {
    qteCmd = value;
  }

  double get qteCmdGet {
    return qteCmd;
  }
}

class CustomListView extends StatelessWidget {
  final List<Product> products;

  CustomListView({this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        return createViewItem(prod, context);
      },
    );
  }
}

Widget createViewItem(Product product, BuildContext context) {
  return ListTile(
    title: new Card(
      elevation: 5.0,
      child: new Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Center(child: CircularProgressIndicator()),
                Center(
                    child: CachedNetworkImage(
                  placeholder: (context, url) => Image.asset(
                      "images/placeholder.png",
                      fit: BoxFit.contain),
                  imageUrl: "${product.image}",
                  fit: BoxFit.cover,
                )),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  child: Text(product.design_produit),
                  padding: EdgeInsets.all(1.0),
                ),
                Text('|'),
                Padding(
                  child: Text('${product.prix_ui}'),
                  padding: EdgeInsets.all(1.0),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future<Map<String, dynamic>> downloadJSON() async {
  final jsonEndPoint = BaseUrl.selectProduct;

  final response = await http.get(jsonEndPoint);

  if (response.statusCode == 200) {
    var products = jsonDecode(response.body);

    return products.map((pr, s) => Product.fromJson(pr[s]));
  } else {
    throw Exception('download failed');
  }
}
