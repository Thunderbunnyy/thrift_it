import 'package:flutter/material.dart';

class SubPageBuyer extends StatefulWidget {
  @override
  _SubPageBuyerState createState() => _SubPageBuyerState();
}

class _SubPageBuyerState extends State<SubPageBuyer> {

  var products_bought = [
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
        itemCount: products_bought.length,
        itemBuilder: (context,index){
          return SingleCartProduct(
            cart_prod_name: products_bought[index]["name"],
            cart_prod_picture: products_bought[index]['picture'],
            cart_prod_price: products_bought[index]['price'],
            cart_prod_size: products_bought[index]['size'],
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
