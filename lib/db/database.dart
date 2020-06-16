import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thriftit/db/product.dart';

class DatabaseService {

  //final String uid;

  //DatabaseService({this.uid});

  //collection reference
  //final CollectionReference users = Firestore.instance.collection('users');
/*
  Future updateUserData(String name, String photoUrl) async{

    return await users.document(uid).setData({
      'name' : name,
      'photoUrl' : '',
    });

  }*/

  final CollectionReference product = Firestore.instance.collection('Products');

  //product list from snapshot
  List<Product> productListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
    return Product(
      brand: doc.data['brand'] ?? '',
      size: doc.data['size'] ?? '',
      images: doc.data['images'] ?? '',
      name: doc.data['name'] ?? '',
      description: doc.data['description'] ?? '',
      state: doc.data['state'] ?? '',
      category: doc.data['category'] ??  '',
      userId: doc.data['userId'] ?? '',
      price: doc.data['price'] ?? '0',
    );
    }).toList();
  }

  /*
  //user data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid : uid,
      username : snapshot.data['username'],
      photoUrl : snapshot.data['photoUrl'],

    );
  }*/

/*
  //get products stream
  Stream<List<Product>> get products {
      return product.snapshots()
      .map(_productListFromSnapshot);
}*/

/*
  //get user doc stream
  Stream<UserData> get userData {
    return users.document(uid).snapshots()
        .map(_userDataFromSnapshot);
  }*/


}

