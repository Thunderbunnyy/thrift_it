import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thriftit/models/product.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {

    final products = Provider.of<List<Product>>(context);
      products.forEach((product){

      });




    return Container();
  }
}
