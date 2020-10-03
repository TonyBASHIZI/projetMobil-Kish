import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:zakuuza/model/api.dart';
import 'package:zakuuza/model/order_list.dart';
import 'package:zakuuza/model/product_mdl.dart';
import 'package:zakuuza/model/user_mdl.dart';
import 'package:http/http.dart' as http;
import 'package:zakuuza/screens/widgets/profile_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmOrderPage extends StatefulWidget {
  final Users users;
  final List<Product> products;

  const ConfirmOrderPage({this.users, this.products});
  @override
  _ConfirmOrderPageState createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {

  _launchURL(String newUrl) async {
    String url = newUrl;
    if (await canLaunch(url)) {
      await launch(url,);
    } else {
      throw 'Could not launch $url';
    }
  }
  final String address = "Chabahil, Kathmandu";

  String phone = "";
  double total = 0.0;
  double delivery = 0.0;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    phone = "${widget.users.telephone}";
    total = getSumPrice();
    delivery = 0.0;
  }

  double getSumPrice() {
    double totalPrice = 0;
    if (OrderList.products.length == 0) {
      totalPrice = 0;
    } else {
      for (var i = 0; i < OrderList.products.length; i++) {
        double qty =
            OrderList.products[i].qty == null ? 1 : OrderList.products[i].qteCmd;
        totalPrice +=
            qty * double.tryParse(OrderList.products[i].prix_ui.toString());
      }
    }
    OrderList.total = totalPrice;
    return OrderList.total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
      ),
      body: ModalProgressHUD(
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
            // backgroundColor: Theme.of(context).primaryColor,
            ),
        inAsyncCall: _saving,
        child: _buildBody(context),
      ),
    );
  }

  showsuccesdialog() {
    showDialog(
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
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // setState(() {
                      //   OrderList.products.clear();
                      // });
                      // Navigator.pop(context);
                      Navigator.of(context).pop();
                      // _setCount();
                    },
                  )
                ],
              ),
            ),
          ),
    );
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

  postBag() async {
    try {
      final url = BaseUrl.panierUrl;
      final detail = BaseUrl.panierdetailsUrl;
      final response = await http.post(url, body: {
        "userID": widget.users.id,
        "total": total.toString().trim()
        });
      // final response = await http.post(urls);
      if (response.statusCode == 200) {
        print(response.body);
        var id = json.decode(response.body)[0]['id'];

        for (var i = 0; i < OrderList.products.length; i++) {
          await http.post(detail, body: {
            "bagID": id,
            "productID": OrderList.products[i].id,
            "qty": OrderList.products[i].qteCmd.toString(),
          });
        }
        setState(() {
          _saving = false;
        });
        Navigator.of(context).pop();
        showsuccesdialog();
        // _setCount();
        setState(() {
          OrderList.products.clear();
        });
        var urls='https://api-testbed.maxicashapp.com/payentry?data={"PayType":"MaxiCash","Amount":"'+ (double.parse(total.toString().trim())*100).toString().trim() +'",Currency:"maxiDollar","Telephone":"0973697114","MerchantID":"6db7867d56b34d92949ba61ffa556a5d","MerchantPassword":"9954bddd185f445c90d8f5cd1bbb2d9b","Language":"fr","Reference":"${id.toString().trim()}","accepturl":"https://www.zakuuza.com/API/api/accept/acceptUrl.php","cancelurl":"https://www.zakuuza.com/API/api/accept/failUrl.php","declineurl":"https://www.zakuuza.com/API/api/accept/failUrl.php","notifyURL":"ffffffff"}';
        _launchURL(urls);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("countCmd",(int.parse(prefs.getString('countCmd')) + 1).toString());
      }
      else{
        print(response.body);
      }
      setState(() {
        _saving = false;
      });
    } catch (e) {
      setState(() {
        _saving = false;
      });
      print(e.toString());
    }
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Subtotal"),
              Text("\$ $total"),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Delivery fee"),
              Text("\$ $delivery"),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: Theme.of(context).textTheme.title,
              ),
              Text("\$ ${total + delivery}",
                  style: Theme.of(context).textTheme.title),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text(
              "Identity".toUpperCase(),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('${widget.users.fullname}'),
              ),
              Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                child: Text(
                  "Contact Number".toUpperCase(),
                ),
              ),
              RadioListTile(
                selected: true,
                value: phone,
                groupValue: phone,
                title: Text(phone),
                onChanged: (value) {},
              ),
              RadioListTile(
                selected: false,
                value: "New Phone",
                groupValue: phone,
                title: Text("Choose new contact number"),
                onChanged: (value) {},
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: Text(
              "Payment Option".toUpperCase(),
            ),
          ),
          RadioListTile(
            groupValue: true,
            value: true,
            title: Text("Cash on Delivery"),
            onChanged: (value) {},
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                setState(() {
                  _saving = true;
                });
                postBag();
              },
              child: Text(
                "Confirm Order",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
