import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubPageBuyer extends StatefulWidget {
  @override
  _SubPageBuyerState createState() => _SubPageBuyerState();
}

class _SubPageBuyerState extends State<SubPageBuyer> {
/*
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

  ];*/

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('Purchases').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return SingleCartProduct(
                cart_prod_name: snapshot.data.documents[index]['productName'],
                cart_prod_picture: snapshot.data.documents[index]['producImage'],
                cart_prod_price: snapshot.data.documents[index]['productPrice'],
              );
            }
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
        leading: Image.network(cart_prod_picture,width: 100,height: 100),
        title: Text('${cart_prod_name}'),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
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
