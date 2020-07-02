import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thriftit/screens/home.dart';
import 'package:thriftit/utils/file_util.dart';
import 'package:stripe_payment/stripe_payment.dart';

class AddCard extends StatefulWidget {


  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isCvvFocused = false;
/*
 File jsonFile;
  Directory dir;
  String fileName = "pay.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;*/

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
        iconTheme: new IconThemeData(color: Colors.red[300]),
        title: Text('Type your credit card info'),
        actions: <Widget>[

        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
                child: CreditCardForm(
                    onCreditCardModelChange: onModelChange,
                ),
              ),

            OutlineButton(
              child: Text(
                'Add Card',
                style: TextStyle(color: Colors.red[300]),
              ),
              onPressed: (){
                try{
                  Firestore.instance.collection("CreditCard").document().setData({
                    'CardNumber' : cardNumber,
                    'expiryDate' : expiryDate,
                    'cardHolderName' : cardHolderName,
                    'cvvCode' : cvvCode,
                    'Credit' : '500',
                    'user' : loggedInUser.uid
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));

                } on PlatformException catch (e){
                  return e.details;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              ),
            )
          ],
        ),
      ),
    );
  }

  void onModelChange(CreditCardModel model) {
    setState(() {
      cardNumber= model.cardNumber;
      expiryDate = model.expiryDate;
      cardHolderName = model.cardHolderName;
      cvvCode = model.cvvCode;
      isCvvFocused = model.isCvvFocused;
    });
  }


}
