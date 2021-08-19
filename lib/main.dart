import 'package:flutter/material.dart';
import 'package:zakuuza/menu.dart';
import 'package:zakuuza/model/order_list.dart';
import 'package:zakuuza/screens/pages/cart/cart1.dart';
import 'package:zakuuza/screens/pages/login/login.dart';
import 'package:zakuuza/screens/pages/search/search_screen.dart';
import 'package:zakuuza/screens/pages/profile.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primaryColor: Colors.white, primarySwatch: Colors.red),
      title: "Vente des immobiliers",
      home: MyHomePage(),
      routes: {"/loginPage": (context) => LoginPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  TabController controller;
  final _home = MyHome();
  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 4);
    // controller=new TabController(length: 4);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.orange,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 5.0,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.person_outline,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          _home,
          SearchScreen(),
          CartOnePage(products: OrderList.products),
          ProfilePage()
          // LoginScreen()
        ],
      ),
    );
  }
}
