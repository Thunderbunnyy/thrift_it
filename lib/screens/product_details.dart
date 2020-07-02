import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thriftit/components/constants.dart';
import 'package:thriftit/db/payment-service.dart';
import 'package:thriftit/screens/existing_cards.dart';
import 'package:thriftit/screens/home.dart';
import 'package:thriftit/screens/modify_product.dart';

class ProductDetails extends StatefulWidget {
  final prod_detail_seller;
  final prod_detail_sellerimg;
  final prod_detail_pic;
  final prod_detail_price;
  final prod_detail_size;
  final prod_detail_brand;
  final prod_detail_state;
  final prod_detail_description;
  final prod_detail_name;

  ProductDetails(
      {this.prod_detail_seller,
      this.prod_detail_sellerimg,
      this.prod_detail_pic,
      this.prod_detail_price,
      this.prod_detail_size,
      this.prod_detail_brand,
      this.prod_detail_state,
      this.prod_detail_description,
      this.prod_detail_name});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
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
    StripeService.init();
    getCurrentUserFromFS(loggedInUser);
    String id = "20FhJpuLgBsVCbkM71M2";
    deletePost(id);
  }

  void onItemPress(BuildContext context, int index) async{
    switch(index){
      case 0:
        var response = await StripeService.payWithNewCard(
          amount: '150',
          currency: 'usd'
        );
        try{
          Firestore.instance.collection("Purchases").document().setData({
            'productName' : widget.prod_detail_name,
            'productPrice' : widget.prod_detail_price,
            'producImage' : widget.prod_detail_pic,
            'user' : loggedInUser.uid
          });

        } on PlatformException catch (e){
          return e.details;
        }
        Navigator.of(context, rootNavigator: true).pop(context);
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(response.message),
            duration: new Duration(milliseconds: 5000),
          ));


        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ExistingCards()));
        break;
      case 2:
        try{
          Firestore.instance.collection("Purchases").document().setData({
            'productName' : widget.prod_detail_name,
            'productPrice' : widget.prod_detail_price,
            'producImage' : widget.prod_detail_pic,
            'user' : loggedInUser.uid
          });

        } on PlatformException catch (e){
          return e.details;
        }
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
        break;
    }
  }

  createAlertDialog(BuildContext context){
    return showDialog(context: context,builder: (context){
      return SimpleDialog(
        title: Text("Choose payment method"),
        children: <Widget>[
          Container(
            height:200,
            width: 300,
            child: ListView.separated(
                itemBuilder: (context,index){
                  Icon icon;
                  Text  text;
                  switch(index){
                    case 0:
                      icon =  Icon(Icons.add_circle, color: Colors.red[300]);
                      text = Text("Payment with new card");
                      break;
                    case 1:
                      icon =  Icon(Icons.credit_card, color: Colors.red[300]);
                      text = Text("Payment with existing card");
                      break;
                    case 2:
                      icon =  Icon(Icons.local_shipping, color: Colors.red[300]);
                      text = Text("Payment after delivery");
                      break;
                  }
                  return InkWell(
                    onTap: (){
                      onItemPress(context,index);
                    },
                    child: ListTile(
                      title: text,
                      leading: icon,
                    ),
                  );
                },
                separatorBuilder: (context,index)=> Divider(
                  color: Colors.red[300],
              ),
                itemCount: 3,

            ),
          )
        ],
      );
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          height: 300.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0)
              ]),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Carousel(
                  boxFit: BoxFit.cover,
                  images: [
                    Image.network(widget.prod_detail_pic),
                    //AssetImage('assets/images/m1.jpg'),
                    //AssetImage('assets/images/w1.jpg'),
                  ],
                  autoplay: false,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  showIndicator: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              )
            ],
          )),
      Expanded(
          child: ListView(
        children: <Widget>[
          Container(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.prod_detail_sellerimg),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${widget.prod_detail_price}DT'),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                        iconSize: 30.0,
                      )
                    ],
                  )
                ],
              ),
              subtitle: Text('${widget.prod_detail_name}'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 6.0,
                  children: <Widget>[
                    Chip(
                      label: Text('Size :${widget.prod_detail_size}'),
                    ),
                    Chip(
                      label: Text('Brand :${widget.prod_detail_brand}'),
                    ),
                  ]),
            ),
          ),
          Divider(
            color: Colors.black12,
          ),
          ListTile(
            title: Text('Description :'),
            subtitle: Text('${widget.prod_detail_description}'),
          ),
          ListTile(
            title: Text('Comments :'),
          ),
        ],
      )),
      FloatingActionButton.extended(
        onPressed: () {
          createAlertDialog(context);
        },
        icon: Icon(Icons.shopping_cart),
        label: Text("Buy now"),
        backgroundColor: Colors.red[300],
      ),
    ]));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Modify) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ModifyProduct()));
    } else if (choice == Constants.Delete) {
      deletePost("20FhJpuLgBsVCbkM71M2");
    }
  }

  void deletePost(String id) {
    Firestore.instance
        .collection('Products')
        .document(id)
        .delete()
        .then((value) {
      print('');
    });
  }


}
/*
class SimilarProducts extends StatefulWidget {
  @override
  _SimilarProductsState createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {

  var product_list = [

    {
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/hills1.jpeg",
      "price": 80,
      "size": "36",
    },
    {
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/skt1.jpeg",
      "price": 60,
      "size": "xs",
    },
    {
      "sellerImage": "",
      "seller": "Nour",
      "picture": "assets/images/dress2.jpeg",
      "price": 150,
      "size": "xs",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate:
        new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SimilarSingleprod(
            seller_image: product_list[index]['seller_image'],
            prod_seller: product_list[index]['seller'],
            prod_picture: product_list[index]['picture'],
            prod_price: product_list[index]['price'],
            prod_size: product_list[index]['size'],
          );
        });
  }
}

class SimilarSingleprod extends StatelessWidget {
  final seller_image;
  final prod_seller;
  final prod_picture;
  final prod_price;
  final prod_size;

  SimilarSingleprod({
    this.seller_image,
    this.prod_seller,
    this.prod_picture,
    this.prod_price,
    this.prod_size,
  });

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
                    prod_detail_sellerimg : seller_image,
                    prod_detail_pic : prod_picture,
                    prod_detail_price : prod_price,
                    prod_detail_size : prod_size,
                  ))),
              child: GridTile(
                  footer: Container(
                      height: 30.0,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                "$prod_price DT" ,
                                style: TextStyle(fontSize: 13.0),
                              )
                          ),
                          Text(prod_size, style: TextStyle(color: Colors.red,fontSize: 13.0)),
                          IconButton(icon: Icon(Icons.favorite,size: 20.0,color: Colors.black12,), onPressed: () {}),
                        ],
                      )
                  ),
                  child: Image.asset(
                    prod_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
*/
