import 'package:flutter/material.dart';

class SubPageSeller extends StatefulWidget {
  @override
  _SubPageSellerState createState() => _SubPageSellerState();
}

class _SubPageSellerState extends State<SubPageSeller> {

  var products_sold = [
    {
      "name": "Blazer",
      "picture": "assets/images/blazer1.jpeg",
      "price": 120,
      "size": "xs",
    },
    {
      "name": "Dress",
      "picture": "assets/images/dress1.jpeg",
      "price": 100,
      "size": "xs",
    },

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: products_sold.length,
        itemBuilder: (context,index){
          return SingleCartProduct(
            cart_prod_name: products_sold[index]["name"],
            cart_prod_picture: products_sold[index]['picture'],
            cart_prod_price: products_sold[index]['price'],
            cart_prod_size: products_sold[index]['size'],
          );
        }
    );
  }
}

class SingleCartProduct extends StatelessWidget {

  final cart_prod_name;
  final cart_prod_picture;
  final cart_prod_price;
  final cart_prod_size;


  SingleCartProduct({this.cart_prod_name, this.cart_prod_picture,
      this.cart_prod_price, this.cart_prod_size});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(cart_prod_picture,width: 100,height: 100),
        title: Text(cart_prod_name),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(cart_prod_size),
                ),
                Expanded(
                  child: Text("$cart_prod_price DT",style: TextStyle(color: Colors.red),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

