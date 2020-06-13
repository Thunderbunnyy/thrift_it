import 'package:flutter/material.dart';
import 'package:thriftit/screens/sub_page_buyer.dart';
import 'package:thriftit/screens/sub_page_seller.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Colors.red[300]),
          title: Text('My cart',style: TextStyle(color: Colors.red[300]),),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.red[300],
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.red[300]),
            tabs: <Widget>[
              Tab(child: Align(
                alignment: Alignment.center,
                child: Text("Sold products"),
              ),),
              Tab(child: Align(
                alignment: Alignment.center,
                child: Text("Bought products"),
              ),)
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SubPageSeller(),
            SubPageBuyer()
          ],
        ),
      ),
    );
  }
}
