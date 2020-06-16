import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thriftit/components/app_data.dart';
import 'package:thriftit/components/product_tools.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thriftit/screens/home.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;


  List<DropdownMenuItem<String>> dropDownStates;
  String selectedState;
  List<String> stateList = new List();

  List<DropdownMenuItem<String>> dropDownSizes;
  String selectedSize;
  List<String> sizeList = new List();

  List<DropdownMenuItem<String>> dropDownCategories;
  String selectedCategory;
  List<String> categoryList = new List();

  TextEditingController productNameController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController productDescController = new TextEditingController();
  TextEditingController productBrandController = new TextEditingController();

  //Map<int, File> imagesMap = new Map();

  final scaffoldKey = new GlobalKey<ScaffoldState>();

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

    stateList = new List.from(localStates);
    sizeList = new List.from(localSizes);
    categoryList = new List.from(localCategories);

    dropDownStates = buildAndGetDropDownItems(stateList);
    dropDownSizes = buildAndGetDropDownItems(sizeList);
    dropDownCategories = buildAndGetDropDownItems(categoryList);

    selectedState = dropDownStates[0].value;
    selectedSize = dropDownSizes[0].value;
    selectedCategory = dropDownCategories[0].value;

    getCurrentUserFromFS(loggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red[300]),
        title: Text('Add a product'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: new RaisedButton.icon(
                color: Colors.red[300],
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(15.0))),
                onPressed: () => pickImage(),
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: new Text(
                  "Add Images",
                  style: new TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              height: 10.0,
            ),
            MultiImagePickerList(
                imageList: imageList,
                removeNewImage: (index) {
                  removeImage(index);
                }),
            new SizedBox(
              height: 10.0,
            ),
            productTextField(
                textTitle: "Product Name",
                textHint: "Enter Product Name",
                controller: productNameController),
            new SizedBox(
              height: 10.0,
            ),
            productTextField(
                textTitle: "Product Price",
                textHint: "Enter Product Price",
                textType: TextInputType.number,
                controller: productPriceController),
            new SizedBox(
              height: 10.0,
            ),
            productTextField(
              textTitle: "Product Brand",
              textHint: "Enter Brand",
              controller: productBrandController,),
            productTextField(
                textTitle: "Product Description",
                textHint: "Enter Description",
                controller: productDescController,
                height: 80.0),
            new SizedBox(
              height: 10.0,
            ),
            productDropDown(
                textTitle: "Product Category",
                selectedItem: selectedCategory,
                dropDownItems: dropDownCategories,
                changedDropDownItems: changedDropDownCategory),
            productDropDown(
                textTitle: "State",
                selectedItem: selectedState,
                dropDownItems: dropDownStates,
                changedDropDownItems: changedDropDownState),
            productDropDown(
                textTitle: "Size",
                selectedItem: selectedSize,
                dropDownItems: dropDownSizes,
                changedDropDownItems: changedDropDownSize),
            new SizedBox(
              height: 20.0,
            ),
            appButton(
              btnTxt: "Sell !",
              onBtnclicked: addNewProducts,
              btnPadding: 20.0,
            )
          ],
        ),
      ),
    );
  }

  void changedDropDownState(String selectedCategory) {
    setState(() {
      selectedState = selectedCategory;
    });
  }

  void changedDropDownCategory(String selectedSize) {
    setState(() {
      selectedCategory = selectedSize;
    });
  }

  void changedDropDownSize(String selected) {
    setState(() {
      selectedSize = selected;
    });
  }

  Future uploadImages() async {

    List<String> imageUrl = new List();

    try{
      for( int s=0; s<imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
          .ref()
            .child("$s.jpg");

        storageReference.putFile(imageList[s]);

        String url = await storageReference.getDownloadURL();
        imageUrl.add(url);

      }
    } on PlatformException catch(e){
        print(e.details);
    }

    return imageUrl;
  }

  List<File> imageList;

  pickImage() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      List<File> imageFile = new List();
      imageFile.add(file);

      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {});
    }
  }

  removeImage(int index) async {
    //imagesMap.remove(index);
    imageList.removeAt(index);
    setState(() {});
  }

  addNewProducts() async {

    if (imageList == null || imageList.isEmpty) {
      showSnackBar("Product Images cannot be empty", scaffoldKey);
      return;
    }

    if (productNameController.text == "") {
      showSnackBar("Product Title cannot be empty", scaffoldKey);
      return;
    }

    if (productPriceController.text == "") {
      showSnackBar("Product Price cannot be empty", scaffoldKey);
      return;
    }

    if (productDescController.text == "") {
      showSnackBar("Product Description cannot be empty", scaffoldKey);
      return;
    }

    if (selectedCategory == "Select Product category") {
      showSnackBar("Please select a category", scaffoldKey);
      return;
    }

    if (selectedState == "Enter a state ") {
      showSnackBar("Please select a state", scaffoldKey);
      return;
    }

    if (selectedSize == "Enter a size") {
      showSnackBar("Please select a size", scaffoldKey);
      return;
    }
    
    try{
      Firestore.instance.collection("Products").document().setData({
      'productImage' : await uploadImages(),
      'productName' : productNameController.text,
      'productDesc' : productDescController.text,
      'productPrice' : productPriceController.text,
        'productBrand' : productBrandController.text,
      'productSize' : selectedSize,
      'productState' : selectedState,
      'productCategory': selectedCategory,
      'user' : loggedInUser.uid

      });

      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

    } on PlatformException catch (e){
      return e.details;
    }
  }
}
