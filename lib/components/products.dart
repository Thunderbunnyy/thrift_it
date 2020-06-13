import 'package:flutter/material.dart';
import 'package:thriftit/screens/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: product_list.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Single_prod(
            seller_image: product_list[index]['seller_image'],
            prod_seller: product_list[index]['seller'],
            prod_picture: product_list[index]['picture'],
            prod_price: product_list[index]['price'],
            prod_size: product_list[index]['size'],
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final seller_image;
  final prod_seller;
  final prod_picture;
  final prod_price;
  final prod_size;

  Single_prod({
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
