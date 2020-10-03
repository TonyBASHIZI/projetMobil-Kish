import 'package:flutter/material.dart';
import 'package:zakuuza/model/product_mdl.dart';

class ProductCart extends StatefulWidget {
  final Product product;

  const ProductCart({this.product});
  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ShoppingCart(
          product: widget.product,
        ),
        Divider()
      ],
    );
  }
}

class ShoppingCart extends StatelessWidget {
  final Product product;
  const ShoppingCart({this.product});
  @override
  Widget build(BuildContext context) {
    double qty = product.qty==null ? 1 : product.qty;
    double total = qty * double.tryParse(product.prix_ui.toString());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Card(elevation: 0.0,
          child: Container(
            // color: Colors.orange[50],
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(0.2),
              child: Image.network(product.image),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(product.detail,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              SizedBox(height: 10.0),
                Text('$qty'),
              SizedBox(height: 5.0),
              Text('Price ${product.prix_ui} \$'),
              SizedBox(height: 5.0),
              Text('Cat Clothes', style: TextStyle(fontSize: 12.0)),
              SizedBox(height: 5.0),
              Text('Total Price $total \$',
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.all(10.0),
              color: Colors.purple,
              onPressed: () {},
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              color: Colors.redAccent,
              onPressed: () {},
              icon: Icon(Icons.remove_circle_outline),
            )
          ],
        )
      ],
    );
  }
}
