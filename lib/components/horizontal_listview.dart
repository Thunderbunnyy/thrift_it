import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
        Category(
          image_location:'assets/images/tshirt.png',
          image_caption: 'T-shirts',
        ),
          Category(
            image_location:'assets/images/dress.png',
            image_caption: 'Dresses',
          ),
          Category(
            image_location:'assets/images/formal.png',
            image_caption: 'Formal',
          ),
          Category(
            image_location:'assets/images/informal.png',
            image_caption: 'Informal',
          ),
          Category(
            image_location:'assets/images/shoe.png',
            image_caption: 'Shoes',
          ),
          Category(
            image_location:'assets/images/jeans.png',
            image_caption: 'Pants',
          ),
          Category(
            image_location:'assets/images/accessories.png',
            image_caption: 'Accessories',
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {

  final String image_location;
  final String image_caption;

  Category({this.image_location, this.image_caption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: 100.0,
          child: ListTile(
            title: Image.asset(image_location,height: 80.0,width: 100.0),
            subtitle: Container(
              alignment: Alignment.topCenter,
              child: Text(image_caption),
            ),
          ),
        ),
      ),
    );
  }
}

