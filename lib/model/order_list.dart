import 'package:zakuuza/model/product_mdl.dart';

class OrderList {
  final String user;
  static List products = [];
  static double total;

  OrderList({this.user, products, total});

  static void add2Cart(Product product) {
    if (products.length == 0) {
      products.add(product);
    } else {
      bool exists = false;
      for (var i = 0; i < products.length; i++) {
        if (products[i].id == product.id) {
          exists = true;
          break;
        }
      }
      exists ? exists = true : products.add(product);
    }
  }

  static void remove2Cart(Product product) {
    var prodIndex = 0;
    if (products.length == 0) {
      // products.add(product);
    } else {
      bool exists = false;
      for (var i = 0; i < products.length; i++) {
        if (products[i].id == product.id) {
          exists = true;
          prodIndex = i;
          break;
        }
      }
      exists ? products.removeAt(prodIndex) : exists = false;
    }
  }
}
