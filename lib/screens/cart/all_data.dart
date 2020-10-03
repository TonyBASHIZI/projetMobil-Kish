import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/product_mdl.dart';
// import 'package:zakuuza/screens/widgets/color_loader_4.dart';

class AllData extends StatefulWidget {
  @override
  _AllDataState createState() => _AllDataState();
}

class _AllDataState extends State<AllData> {
  // var _isLoading = false;
  var data;
  final listProduct = new List<Product>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new FutureBuilder<List>(
          future: getData(),
          // future: downloadJSON(),
          builder: (cxt, ss) {
            // if (ss.hasError) return new Center(child: Text('Please check your internet connection'));
            if (ss.hasError) {
              print(ss.error);
              return new Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200.0,
                      width: 200.0,
                      child: Image.asset('images/404.gif'),
                    ),
                    Text("Erreur de serveur")
                  ],
                ),
              );
            }
            return ss.hasData
                ? new CustomListView(products: ss.data)
                : new Center(child: CircularProgressIndicator(backgroundColor: Colors.deepOrange,));
          }),
    );
  }

  Future<List<Product>> getData() async {
    final url = BaseUrl.selectProduct;
    final response = await http.get(url);
    data = json.decode(response.body);
    return List.generate(data.length, (i) {
      print(data[i]);
      return Product(
          id: data[i]['id'],
          design_produit: data[i]['design_produit'],
          detail: data[i]['detail'],
          prix_ui: double.tryParse(data[i]['prix_ui']),
          categorie: data[i]['categorie'],
          fss: data[i]['fss'],
          image: BaseUrl.uploadUrl + data[i]['image']);
    });
  }
}

class Items extends StatelessWidget {
  final List list;
  Items({this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: Icon(Icons.widgets),
          title: Text(list[i]['design_produit']),
          subtitle: Text(list[i]['prix_ui']),
        );
      },
    );
  }
}
