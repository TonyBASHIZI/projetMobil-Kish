import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/category_mdl.dart';
import 'package:zakuuza/screens/pages/search/search_category.dart';

class HorizontalList extends StatelessWidget {
  var data;
  final listProduct = new List<Category>();
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      height: 80.0,
      child: FutureBuilder<List>(
          future: getData(),
          builder: (cxt, ss) {
            if (ss.hasError) return new Center();
            return ss.hasData
                ? new ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: ss.data.length,
                    itemBuilder: (context, i) {
                      return new Categoris(
                        cat: ss.data[i],
                      );
                    },
                  )
                : new Center(child: CupertinoActivityIndicator());
          }),
    );
  }

  Future<List<Category>> getData() async {
    final url = BaseUrl.selectCategory;
    final response = await http.get(url);
    data = json.decode(response.body);
    // print(response.body);
    data.forEach((api) {
      var category = Category.fromJson(api);
      listProduct.add(category);
    });
    return listProduct;
  }
}

class Categoris extends StatelessWidget {
  final Category cat;

  //Making
  Categoris({this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(cat.id.toString() + "tapped");
        // showsuccesdialog(context);
        // _searchData(cat.name.toString().trim());
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new SearchCategoryScreen(
                categoryName: cat.name.toString().trim())));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      image: NetworkImage(cat.image.toString().trim()),
                      fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
    );
  }
}

class Categories extends StatefulWidget {
  final Category cat;
  Categories({this.cat});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new SearchCategoryScreen(
                categoryName: widget.cat.name.toString().trim())));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        width: 70,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 230, 1),
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      image: NetworkImage(widget.cat.image.toString().trim()),
                      fit: BoxFit.cover)),
              // child: Text(widget.cat.name.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
