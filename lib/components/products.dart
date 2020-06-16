import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thriftit/screens/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  /*
  var product_list = [
    {
      "name": "Blazer",
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/blazer1.jpeg",
      "price": 120,
      "size": "xs",
    },
    {
      "name": "Dress",
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/dress1.jpeg",
      "price": 100,
      "size": "xs",
    },
    {
      "name": "Heals",
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/hills1.jpeg",
      "price": 80,
      "size": "36",
    },
    {
      "name": "Skirt",
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/skt1.jpeg",
      "price": 60,
      "size": "xs",
    },
    {
      "name": "Dress",
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/dress2.jpeg",
      "price": 150,
      "size": "xs",
    }
  ];*/
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;

  Future<DocumentSnapshot> getCurrentUserFromFS(FirebaseUser user) async {

    final user = await _auth.currentUser();
    loggedInUser = user;

    try {
      if (user != null) {
        print("user id is ${user.uid}");
        return Firestore.instance.collection('users').document(user.uid).get();

      } else {
        print("user is null");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


  @override
  void initState() {
    super.initState();
    getCurrentUserFromFS(loggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('Products').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const Text('Loading events...'));
          }
          return GridView.builder(
              itemCount: snapshot.data.documents.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return Single_prod(
                  seller_image: loggedInUser.photoUrl,
                  prod_seller: loggedInUser.displayName,
                  prod_picture: snapshot.data.documents[index]['productImage'][0],
                  prod_price: snapshot.data.documents[index]['productPrice'],
                  prod_size: snapshot.data.documents[index]['productSize'],
                  prod_brand: snapshot.data.documents[index]['productBrand'],
                  prod_desc: snapshot.data.documents[index]['productDesc'],
                  prod_category : snapshot.data.documents[index]['productCategory'],
                  prod_name: snapshot.data.documents[index]['productName'],
                );
              });
        });
  }
}

class Single_prod extends StatelessWidget {
  final seller_image;
  final prod_seller;
  final prod_picture;
  final prod_price;
  final prod_size;
  final prod_brand;
  final prod_desc;
  final prod_category;
  final prod_name;


  Single_prod({this.seller_image, this.prod_seller, this.prod_picture,
      this.prod_price, this.prod_size, this.prod_brand, this.prod_desc,
      this.prod_category,this.prod_name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: Text("hero 1"),
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => ProductDetails(
                        prod_detail_seller: prod_seller,
                        prod_detail_sellerimg: seller_image,
                        prod_detail_pic: prod_picture,
                        prod_detail_price: prod_price,
                        prod_detail_size: prod_size,
                        prod_detail_brand : prod_brand,
                        prod_detail_description: prod_desc,
                        prod_detail_name: prod_name,
                      ))),
              child: GridTile(
                  footer: Container(
                      height: 30.0,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                            "$prod_price DT",
                            style: TextStyle(fontSize: 13.0),
                          )),
                          Text(prod_size,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 13.0)),
                          IconButton(
                              icon: Icon(
                                Icons.favorite,
                                size: 20.0,
                                color: Colors.black12,
                              ),
                              onPressed: () {}),
                        ],
                      )),
                  child: Image.network(
                    prod_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
