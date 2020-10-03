import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:zakuuza/main.dart';
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/order_list.dart';
import 'package:zakuuza/model/user_mdl.dart';
import 'package:zakuuza/screens/cart/product_cart.dart';
import 'package:zakuuza/screens/widgets/color_loader_4.dart';
import 'package:zakuuza/screens/widgets/profile_tile.dart';
import 'package:http/http.dart' as http;

class PaymentSuccessPage extends StatefulWidget {
  final Users users;

  const PaymentSuccessPage({this.users});
  @override
  PaymentSuccessPageState createState() {
    return new PaymentSuccessPageState();
  }
}

class PaymentSuccessPageState extends State<PaymentSuccessPage> {
  bool isDataAvailable = true;

  Widget myShoppingCart() => ListView.builder(
      itemCount: OrderList.products.length,
      itemBuilder: (context, i) {
        return ProductCart(product: OrderList.products[i],);
      });

  Widget bodyData() => Center(
        child: isDataAvailable
            ? RaisedButton(
                shape: StadiumBorder(),
                onPressed: () => showSuccessDialog(),
                color: Colors.amber,
                child: Text("Confirmer commande"),
              )
            : ColorLoader4(),
      );

  Center confirmWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 100.0,
              color: Colors.orange,
            ),
            SizedBox(
              height: 20.0,
            ),
            ProfileTile(
              title: "Succes",
              subtitle: "commande effecté avec succès",
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => MyHomePage()));
          },
        ),
        centerTitle: true,
        title: Text('Commande'),
      ),
      body: OrderList.products.length == 0 ? confirmWidget() : myShoppingCart(),
      bottomNavigationBar: Container(
        height: 50.0,
        color: Colors.orange,
        child: OrderList.products.length == 0 ? Container() : bodyData(),
      ),
    );
  }

  void showSuccessDialog() {
    setState(() {
      isDataAvailable = false;
      Future.delayed(Duration(seconds: 3)).then((_) => goToDialog());
      // goToDialog();
    });
  }

  Future<bool> postBag() async {
    final url = BaseUrl.panierUrl;
    final detail = BaseUrl.panierdetailsUrl;
    final response = await http.post(url, body: {"userID": widget.users.id});
    if (response.statusCode == 200) {
      var id = json.decode(response.body)[0]['id'];

      for (var i = 0; i < OrderList.products.length; i++) {
        await http.post(detail, body: {
          "bagID": id,
          "productID": OrderList.products[i].id,
          "qty": OrderList.products[i].qteCmd.toString()
        });
      }

      return true;
    }
    return false;
  }

  goToDialog() {
    setState(() {
      isDataAvailable = true;
    });
    postBag() != null
        ? showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          OrderList.products.clear();
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  successTicket() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ProfileTile(
                  title: "Merci!",
                  textColor: Colors.black,
                  subtitle: "Votre commande a été bien envoyé",
                ),
                ListTile(
                  title: Text("Date"),
                  subtitle: Text(DateFormat("MMM d y").format(DateTime.now())),
                  trailing: Text(DateFormat().add_Hm().format(DateTime.now())),
                ),
                ListTile(
                  title: Text('${widget.users.fullname}'),
                  subtitle: Text('${widget.users.email}'),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    radius: 20.0,
                    child: Icon(
                      Icons.email,
                      size: 25.0,
                      color: Colors.red,
                    ),
                    // backgroundImage: NetworkImage(
                    //     "https://avatars0.githubusercontent.com/u/12619420?s=460&v=4"),
                  ),
                ),
                ListTile(
                  title: Text("Montant"),
                  subtitle: Text("\$ ${OrderList.total}"),
                  trailing: Text("Completed"),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0.0,
                  color: Colors.grey[200],
                  child: ListTile(
                    leading: Icon(
                      Icons.notifications_active,
                      color: Colors.red,
                    ),
                    title: Text("Message de confirmation au"),
                    subtitle: Text(widget.users.telephone),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
