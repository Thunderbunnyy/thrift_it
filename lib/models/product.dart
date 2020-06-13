import 'package:cloud_firestore/cloud_firestore.dart';

class Product {

    final String brand;
    final String size ;
    final List<String> images;
    final String name;
    final String description;
    final String state;
    final String category;
    final String userId ;
    final int price ;

    Product({this.brand, this.size, this.images, this.name, this.description,
      this.state, this.category, this.userId, this.price});
}