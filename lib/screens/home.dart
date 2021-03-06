import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thriftit/components/products.dart';
import 'package:thriftit/utils/auth_util.dart';
import 'package:thriftit/screens/add_card.dart';
import 'package:thriftit/screens/add_products.dart';
import 'package:thriftit/screens/cart.dart';
import 'package:thriftit/screens/login.dart';
import 'package:thriftit/screens/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


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
    Widget imageCarousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/w3.jpeg'),
          AssetImage('assets/images/m1.jpeg'),
          AssetImage('assets/images/c1.jpg'),
          AssetImage('assets/images/w4.jpeg'),
        ],
        autoplay: false,
//      animationCurve: Curves.fastOutSlowIn,
//      animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red[300]),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.red[300],
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
              }),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.red[300],
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.red[300],
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()));
              }),
        ],
      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
//            header
            StreamBuilder(
          stream: Firestore.instance.collection('Users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return UserAccountsDrawerHeader(
              accountName: Text("${loggedInUser?.displayName}"),
              accountEmail: Text("${loggedInUser?.email}"),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: NetworkImage("${loggedInUser?.photoUrl}"),
                  backgroundColor: Colors.grey,
                  
                ),
              ),
              decoration: new BoxDecoration(color: Colors.red[300]),
            );
          }
             ,
            ),

//            body

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home, color: Colors.red[300]),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('My account'),
                leading: Icon(Icons.person, color: Colors.red[300]),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCard()));
              },
              child: ListTile(
                title: Text('Add credit card info'),
                leading: Icon(Icons.credit_card, color: Colors.red[300]),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: ListTile(
                title: Text('Sell something !'),
                leading: Icon(Icons.add_a_photo, color: Colors.red[300]),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()));
              },
              child: ListTile(
                title: Text('Cart'),
                leading: Icon(Icons.shopping_basket, color: Colors.red[300]),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Favourites'),
                leading: Icon(Icons.favorite, color: Colors.red[300]),
              ),
            ),

            Divider(),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About'),
                leading: Icon(Icons.help, color: Colors.green),
              ),
            ),
            InkWell(
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
              },
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.exit_to_app, color: Colors.amber),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          //image carousel begins here
          imageCarousel,

          /*
          //padding widget
          new Padding(padding: const EdgeInsets.all(8.0),
            child: new Text('Categories'),),

          //Horizontal list view begins here
          HorizontalList(),
*/
          //padding widget
          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Text('Recent products'),
          ),
          //grid view
          Container(
            height: 320.0,
            child: Products(),
          )
        ],
      ),
    );
  }
}
